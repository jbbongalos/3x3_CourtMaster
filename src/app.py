from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = "basketball_project_key"

# --- DATABASE CONNECTION ---
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",  # Default XAMPP
        database="CCCS105"
    )

# --- 1. DASHBOARD (INDEX) ---
@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT COUNT(*) as count FROM players")
    p_count = cursor.fetchone()['count']
    cursor.execute("SELECT COUNT(*) as count FROM teams")
    t_count = cursor.fetchone()['count']
    cursor.execute("SELECT COUNT(*) as count FROM games")
    g_count = cursor.fetchone()['count']
    cursor.close()
    conn.close()
    return render_template('index.html', p_count=p_count, t_count=t_count, g_count=g_count)

# --- 2. PLAYERS SECTION ---
@app.route('/players')
def players():
    query = request.args.get('query')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if query:
        search_val = f"%{query}%"
        cursor.execute("""
            SELECT players.*, teams.team_name 
            FROM players 
            LEFT JOIN teams ON players.team_id = teams.team_id
            WHERE first_name LIKE %s OR last_name LIKE %s OR position LIKE %s
        """, (search_val, search_val, search_val))
    else:
        cursor.execute("""
            SELECT players.*, teams.team_name 
            FROM players 
            LEFT JOIN teams ON players.team_id = teams.team_id
        """)
    players_list = cursor.fetchall()
    cursor.execute("SELECT * FROM teams")
    teams_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('players.html', players=players_list, teams=teams_list)

@app.route('/edit_player/<int:id>', methods=['GET', 'POST'])
def edit_player(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        fname = request.form['first_name']
        lname = request.form['last_name']
        jersey = request.form['jersey_number']
        pos = request.form['position']
        t_id = request.form['team_id']
        cursor.execute("""
            UPDATE players SET first_name=%s, last_name=%s, jersey_number=%s, position=%s, team_id=%s 
            WHERE player_id=%s
        """, (fname, lname, jersey, pos, t_id, id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('players'))
    
    cursor.execute("SELECT * FROM players WHERE player_id = %s", (id,))
    player = cursor.fetchone()
    cursor.execute("SELECT * FROM teams")
    teams = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('edit_player.html', player=player, teams=teams)

@app.route('/delete_player/<int:id>')
def delete_player(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM players WHERE player_id = %s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('players'))

# --- 3. TEAMS SECTION ---
@app.route('/teams')
def teams():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM teams")
    teams_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('teams.html', teams=teams_list)

# --- 4. GAMES SECTION ---
@app.route('/games')
def games():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT games.*, t1.team_name AS home_team, t2.team_name AS away_team 
        FROM games
        JOIN teams t1 ON games.home_team_id = t1.team_id
        JOIN teams t2 ON games.away_team_id = t2.team_id
    """)
    games_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('games.html', games=games_list)

@app.route('/edit_game/<int:id>', methods=['GET', 'POST'])
def edit_game(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        h_score = request.form['home_score']
        a_score = request.form['away_score']
        venue = request.form['venue']
        cursor.execute("UPDATE games SET home_team_score=%s, away_team_score=%s, venue=%s WHERE game_id=%s", 
                       (h_score, a_score, venue, id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('games'))

    cursor.execute("""
        SELECT g.*, t1.team_name as home, t2.team_name as away 
        FROM games g 
        JOIN teams t1 ON g.home_team_id = t1.team_id 
        JOIN teams t2 ON g.away_team_id = t2.team_id 
        WHERE g.game_id = %s""", (id,))
    game = cursor.fetchone()
    cursor.close()
    conn.close()
    return render_template('edit_game.html', game=game)

if __name__ == '__main__':
    app.run(debug=True)
