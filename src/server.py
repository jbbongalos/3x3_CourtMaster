from flask import Flask, render_template, request, redirect, url_for, flash, Response
import mysql.connector
import csv
import io

server = Flask(__name__)
server.secret_key = "basketball_project_key"

# --- DATABASE CONNECTION ---
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="", 
        database="CCCS105"
    )

# --- 1. DASHBOARD ---
@server.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # Corrected: Capitalized Table Names to match SQL Schema
    cursor.execute("SELECT COUNT(*) as count FROM Players")
    p_count = cursor.fetchone()['count']
    cursor.execute("SELECT COUNT(*) as count FROM Teams")
    t_count = cursor.fetchone()['count']
    cursor.execute("SELECT COUNT(*) as count FROM Games")
    g_count = cursor.fetchone()['count']
    cursor.close()
    conn.close()
    return render_template('index.html', p_count=p_count, t_count=t_count, g_count=g_count)

# --- 2. PLAYERS SECTION ---
@server.route('/players')
def players():
    query = request.args.get('query')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if query:
        search_val = f"%{query}%"
        cursor.execute("""
            SELECT p.*, t.team_name 
            FROM Players p
            LEFT JOIN Teams t ON p.team_id = t.team_id
            WHERE p.first_name LIKE %s OR p.last_name LIKE %s OR p.position LIKE %s OR p.jersey_number LIKE %s
        """, (search_val, search_val, search_val, search_val))
    else:
        cursor.execute("""
            SELECT p.*, t.team_name 
            FROM Players p 
            LEFT JOIN Teams t ON p.team_id = t.team_id
        """)
    players_list = cursor.fetchall()
    cursor.execute("SELECT * FROM Teams")
    teams_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('players.html', players=players_list, teams=teams_list)

@server.route('/add_player', methods=['POST'])
def add_player():
    conn = get_db_connection()
    cursor = conn.cursor()
    t_id = request.form['team_id'] if request.form['team_id'] else None
    cursor.execute("""
        INSERT INTO Players (first_name, last_name, jersey_number, position, team_id) 
        VALUES (%s, %s, %s, %s, %s)
    """, (request.form['first_name'], request.form['last_name'], request.form['jersey_number'], request.form['position'], t_id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('players'))

@server.route('/edit_player/<int:id>', methods=['GET', 'POST'])
def edit_player(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        t_id = request.form['team_id'] if request.form['team_id'] else None
        cursor.execute("""
            UPDATE Players SET first_name=%s, last_name=%s, jersey_number=%s, position=%s, team_id=%s 
            WHERE player_id=%s
        """, (request.form['first_name'], request.form['last_name'], request.form['jersey_number'], request.form['position'], t_id, id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('players'))
    cursor.execute("SELECT * FROM Players WHERE player_id = %s", (id,))
    player = cursor.fetchone()
    cursor.execute("SELECT * FROM Teams")
    teams = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('edit_player.html', player=player, teams=teams)

@server.route('/delete_player/<int:id>')
def delete_player(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Players WHERE player_id = %s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('players'))

# --- 3. TEAMS SECTION ---
@server.route('/teams')
def teams():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Teams")
    teams_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('teams.html', teams=teams_list)

@server.route('/team/<int:id>')
def team_details(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM Teams WHERE team_id = %s", (id,))
    team = cursor.fetchone()
    
    cursor.execute("SELECT * FROM Players WHERE team_id = %s", (id,))
    roster = cursor.fetchall()
    
    cursor.execute("""
        SELECT COUNT(*) as wins FROM Games 
        WHERE (home_team_id = %s AND home_team_score > away_team_score)
        OR (away_team_id = %s AND away_team_score > home_team_score)
    """, (id, id))
    wins = cursor.fetchone()['wins']

    cursor.execute("""
        SELECT COUNT(*) as losses FROM Games 
        WHERE (home_team_id = %s AND home_team_score < away_team_score)
        OR (away_team_id = %s AND away_team_score < home_team_score)
    """, (id, id))
    losses = cursor.fetchone()['losses']
    
    cursor.close()
    conn.close()
    return render_template('team_view.html', team=team, roster=roster, wins=wins, losses=losses)

@server.route('/add_team', methods=['POST'])
def add_team():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Teams (team_name, city, coach_name) VALUES (%s, %s, %s)", 
                   (request.form['team_name'], request.form['city'], request.form['coach_name']))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('teams'))

@server.route('/delete_team/<int:id>')
def delete_team(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM Teams WHERE team_id = %s", (id,))
        conn.commit()
    except mysql.connector.Error:
        flash("Cannot delete team with assigned players or games!")
    finally:
        cursor.close()
        conn.close()
    return redirect(url_for('teams'))

# --- 4. GAMES SECTION ---
@server.route('/games')
def games():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT g.*, 
               IFNULL(t1.team_name, 'TBD') AS home_team, 
               IFNULL(t2.team_name, 'TBD') AS away_team 
        FROM Games g
        LEFT JOIN Teams t1 ON g.home_team_id = t1.team_id
        LEFT JOIN Teams t2 ON g.away_team_id = t2.team_id
        ORDER BY g.game_date ASC
    """)
    games_list = cursor.fetchall()
    cursor.execute("SELECT * FROM Teams")
    teams_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('games.html', games=games_list, teams=teams_list)

@server.route('/add_game', methods=['POST'])
def add_game():
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Games (game_date, home_team_id, away_team_id, home_team_score, away_team_score, venue)
            VALUES (%s, %s, %s, 0, 0, %s)
        """, (request.form['game_date'], request.form['home_team_id'], request.form['away_team_id'], request.form['venue']))
        conn.commit()
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
        conn.close()
    return redirect(url_for('games'))

@server.route('/delete_game/<int:id>')
def delete_game(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Games WHERE game_id = %s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('games'))

@server.route('/edit_game/<int:id>', methods=['GET', 'POST'])
def edit_game(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        cursor.execute("""
            UPDATE Games SET home_team_score=%s, away_team_score=%s, venue=%s 
            WHERE game_id=%s
        """, (request.form['home_score'], request.form['away_score'], request.form['venue'], id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('games'))
    cursor.execute("""
        SELECT g.*, t1.team_name as home, t2.team_name as away 
        FROM Games g 
        JOIN Teams t1 ON g.home_team_id = t1.team_id 
        JOIN Teams t2 ON g.away_team_id = t2.team_id 
        WHERE g.game_id = %s""", (id,))
    game = cursor.fetchone()
    cursor.close()
    conn.close()
    return render_template('edit_game.html', game=game)

# --- 5. EXPORT ---
@server.route('/export_players')
def export_players():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT p.player_id, p.first_name, p.last_name, p.jersey_number, p.position, t.team_name 
        FROM Players p LEFT JOIN Teams t ON p.team_id = t.team_id
    """)
    results = cursor.fetchall()
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(['ID', 'First Name', 'Last Name', 'Jersey', 'Position', 'Team'])
    for row in results:
        writer.writerow([row['player_id'], row['first_name'], row['last_name'], row['jersey_number'], row['position'], row['team_name']])
    cursor.close()
    conn.close()
    return Response(output.getvalue(), mimetype="text/csv", 
                    headers={"Content-disposition": "attachment; filename=roster_export.csv"})

if __name__ == '__main__':
    server.run(debug=True)
