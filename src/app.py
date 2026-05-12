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

# --- 2. PLAYERS SECTION (READ & SEARCH) ---
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

@app.route('/add_player', methods=['POST'])
def add_player():
    fname = request.form['first_name']
    lname = request.form['last_name']
    jersey = request.form['jersey_number']
    pos = request.form['position']
    t_id = request.form['team_id'] if request.form['team_id'] else None

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO players (first_name, last_name, jersey_number, position, team_id) VALUES (%s, %s, %s, %s, %s)", 
                   (fname, lname, jersey, pos, t_id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('players'))

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

@app.route('/add_team', methods=['POST'])
def add_team():
    name = request.form['team_name']
    city = request.form['city']
    coach = request.form['coach_name']
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO teams (team_name, city, coach_name) VALUES (%s, %s, %s)", (name, city, coach))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('teams'))

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
    cursor.execute("SELECT * FROM teams")
    teams_list = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('games.html', games=games_list, teams=teams_list)

@app.route('/add_game', methods=['POST'])
def add_game():
    g_date = request.form['game_date']
    home_id = request.form['home_team_id']
    away_id = request.form['away_team_id']
    h_score = request.form['home_score']
    a_score = request.form['away_score']
    venue = request.form['venue']

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO games (game_date, home_team_id, away_team_id, home_team_score, away_team_score, venue)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (g_date, home_id, away_id, h_score, a_score, venue))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('games'))

if __name__ == '__main__':
    app.run(debug=True)
