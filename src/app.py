from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = "basketball_management_secret"

# 1. DATABASE CONNECTION FUNCTION
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",      # Default XAMPP password is empty
        database="CCCS105"
    )

# 2. HOME PAGE (DASHBOARD)
@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Get total counts for the cards in index.html
    cursor.execute("SELECT COUNT(*) as count FROM players")
    p_count = cursor.fetchone()['count']
    
    cursor.execute("SELECT COUNT(*) as count FROM teams")
    t_count = cursor.fetchone()['count']
    
    cursor.close()
    conn.close()
    return render_template('index.html', player_count=p_count, team_count=t_count)

# 3. VIEW & SEARCH PLAYERS
@app.route('/players')
def players():
    query = request.args.get('query')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if query:
        # Search logic
        sql = """
            SELECT players.*, teams.team_name 
            FROM players 
            LEFT JOIN teams ON players.team_id = teams.team_id
            WHERE first_name LIKE %s OR last_name LIKE %s OR position LIKE %s
        """
        search_val = f"%{query}%"
        cursor.execute(sql, (search_val, search_val, search_val))
    else:
        # Standard view
        cursor.execute("""
            SELECT players.*, teams.team_name 
            FROM players 
            LEFT JOIN teams ON players.team_id = teams.team_id
        """)
    
    players_list = cursor.fetchall()
    
    # Get teams for the "Add Player" dropdown modal
    cursor.execute("SELECT * FROM teams")
    teams_list = cursor.fetchall()
    
    cursor.close()
    conn.close()
    return render_template('players.html', players=players_list, teams=teams_list)

# 4. ADD PLAYER (CREATE)
@app.route('/add_player', methods=['POST'])
def add_player():
    if request.method == 'POST':
        fname = request.form['first_name']
        lname = request.form['last_name']
        jersey = request.form['jersey_number']
        pos = request.form['position']
        t_id = request.form['team_id'] if request.form['team_id'] else None

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO players (first_name, last_name, jersey_number, position, team_id)
            VALUES (%s, %s, %s, %s, %s)
        """, (fname, lname, jersey, pos, t_id))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('players'))

# 5. DELETE PLAYER (DELETE)
@app.route('/delete_player/<int:id>')
def delete_player(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM players WHERE player_id = %s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('players'))

if __name__ == '__main__':
    app.run(debug=True)
