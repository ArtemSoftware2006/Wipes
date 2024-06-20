import os
import json
import mysql.connector
import config

config_path = './db_config.json'
database_config = config.Config(config_path)

connection = mysql.connector.connect(
    host = database_config.connection.host,
    user = database_config.connection.user,
    password = database_config.connection.password,
    database = database_config.connection.database
)

cursor = connection.cursor(buffered=True)

config_data = {}

def load_config():
    global config_data
    with open(config_path, 'r') as f:
        config_data = json.load(f)

def reset_db():
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
    cursor.execute(f"TRUNCATE TABLE {database_config.server.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.player.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.thing.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.thing_in_request.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.discord_account.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.request.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.request_status.table_name};")
    cursor.execute(f"TRUNCATE TABLE {database_config.wipe.table_name};")
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
    
    connection.commit()
    
def add_default_value(): 
     cursor.execute(f"""
                    INSERT INTO {database_config.server.table_name}({database_config.server.columns['name']}) VALUES
                    ('Оазис Кошмаров'),
                    ('Деревушка Керивэлл')
                    """)
     connection.commit()
   
discord_acc_dict = {}     
def insert_discord_data(discord_data):
    if not discord_acc_dict.get(discord_data['discord_nickname']):
        query = f"""
                INSERT INTO {config_data['discord_account']['name']} ({config_data['discord_account']['columns']['discord_name']}) 
                VALUES (%s)"""
        cursor.execute(query, (discord_data['discord_nickname'],))
        
        discord_acc_dict[discord_data['discord_nickname']] = cursor.lastrowid
            
        return cursor.lastrowid
    else:
        return discord_acc_dict[discord_data['discord_nickname']] 

def insert_vape_data(vape_data):
    
    query = f"""
            SELECT {database_config.server.columns['id']} 
            FROM {database_config.server.table_name} 
            WHERE {database_config.server.columns['name']} = %s"""
    cursor.execute(query, (vape_data['server_name'],))
    id_server = cursor.fetchone()
                
    cursor.execute(
        f"""
        INSERT INTO {database_config.wipe.table_name} (
            {database_config.wipe.columns['started_at']}, 
            {database_config.wipe.columns['stoped_at']}, 
            {database_config.wipe.columns['server_id']}
        ) 
        VALUES (%s, %s, %s)
        """, 
        (vape_data['started_at'], vape_data['stoped_at'], id_server[0])
    )
    connection.commit()
    
    return cursor.lastrowid
    
players_dict = {}
def insert_player_data(player_data):
    if not players_dict.get(player_data['dst_nickname']):
        query = f"""
                INSERT INTO {database_config.player.table_name} (
                    {database_config.player.columns['dst_nickname']}, 
                    {database_config.player.columns['discord_id']}
                ) 
                VALUES (%s, %s)
                """
        cursor.execute(query, (player_data['dst_nickname'], player_data['id_discord_accounts'],))
        connection.commit()
        
        players_dict[player_data['dst_nickname']] = cursor.lastrowid
        
        return cursor.lastrowid

    else:
        return players_dict[player_data['dst_nickname']]
    
def insert_claim_data(claim_data):
    query = f"""
            INSERT INTO {database_config.request.table_name}(
                {database_config.request.columns['created_at']}, 
                {database_config.request.columns['approved_at']}, 
                {database_config.request.columns['executed_at']}, 
                {database_config.request.columns['request_status']}, 
                {database_config.request.columns['wipe_id']}, 
                {database_config.request.columns['player_id']}
            ) 
            VALUES (%s, %s, %s, %s, %s, %s)
            """
    cursor.execute(query, (
        claim_data['created_at'], 
        claim_data['approved_at'], 
        claim_data['executed_at'], 
        claim_data['ClaimStatuses_id_claim_status'], 
        claim_data['Vapes_id_vape'], 
        claim_data['Players_id_player'],
    ))
    connection.commit()       
    
    return cursor.lastrowid

claim_statuses = {}
def get_request_status(status):
    if not claim_statuses.get(status):
        query = f"""
            INSERT INTO {database_config.request_status.table_name}(
                {database_config.request_status.columns['status']}
            ) 
            VALUES (%s)
        """
        cursor.execute(query, (status,))
        connection.commit()       
        
        claim_statuses[status] = cursor.lastrowid
    
    return  claim_statuses[status]

thing_dict = {}
def insert_thing_data(thing_data):
    if not thing_dict.get((thing_data['id'])):
        query = f"""
        INSERT INTO {database_config.thing.table_name}(
            {database_config.thing.columns['name']}, 
            {database_config.thing.columns['prefab']}
        ) 
        VALUES (%s, %s)"""
        
        cursor.execute(query, (thing_data['name'], thing_data['id'],))
        connection.commit()       
        
        thing_dict[thing_data['id']] = cursor.lastrowid
    
    return  thing_dict[thing_data['id']]

def insert_thing_claim_data(thing_claim_data):
    query = f"""
            INSERT INTO {database_config.thing_in_request.table_name}(
                {database_config.thing_in_request.columns['claim_id']}, 
                {database_config.thing_in_request.columns['thing_id']}) 
            VALUES (%s, %s)"""
    cursor.execute(query, (thing_claim_data['Claims_id_claim'], thing_claim_data['Things_id_thing'],))
    connection.commit()       
    
    
def main():   
    
    try:
        load_config()
        reset_db()
        add_default_value()
        
        for source_path in config_data['source']:

            # Переход по всем папкам с вайпами
            for wipe_folder in os.listdir(source_path):
                wipe_folder_path = os.path.join(source_path, wipe_folder)
                if os.path.isdir(wipe_folder_path):
                    # Чтение файла wipe.json
                    info_file_path = os.path.join(wipe_folder_path, 'wipe.json')
                    with open(info_file_path, 'r') as f:
                        wipe_data = json.load(f)
                    id_vape = insert_vape_data(wipe_data)
                    # Чтение файлов запросов
                    claims_folder_path = os.path.join(wipe_folder_path, 'claims')
                    for claim_file in os.listdir(claims_folder_path):
                        claim_file_path = os.path.join(claims_folder_path, claim_file)
                        with open(claim_file_path, 'r') as f:
                            claim_data = json.load(f)

                        player = claim_data['player']
                        
                        discord_nickname ={
                            'discord_nickname' : player['discord_nickname']
                        }
                                        
                        id_discord_accounts = insert_discord_data(discord_nickname)
                        dst_nickname = player['dst_nickname']
                        
                        player_data = {
                            'dst_nickname': dst_nickname,
                            'id_discord_accounts' : id_discord_accounts
                        }
                        
                        id_player = insert_player_data(player_data)                
                                
                        claim= {
                            'created_at' : claim_data['created_at'],
                            'approved_at' : claim_data['approved_at'] or None,
                            'executed_at' : claim_data['executed_at'] or None ,
                            'ClaimStatuses_id_claim_status' : get_request_status(claim_data['status']),
                            'Vapes_id_vape' : id_vape,
                            'Players_id_player' : id_player
                        }
                        
                        id_claim = insert_claim_data(claim)
                        
                        things = claim_data['items']
                        for thing in things:
                            id_thing = insert_thing_data(thing)
                            
                            thing_claim_data = {
                                'Claims_id_claim' : id_claim,
                                'Things_id_thing' : id_thing
                            }
                            insert_thing_claim_data(thing_claim_data)
                             
    except Exception as ex:
        print(ex)
        
    finally:
        cursor.close()
        connection.close()
                            
    
if __name__ == '__main__':
    main()