import json


class Config:
        
    def __init__(self, config_path):
        self.config_path = config_path
        self.load_config()
        self.set_entities()
        self.connection = Connection(
            self.config['connection']['host'],
            self.config['connection']['user'],
            self.config['connection']['password'],
            self.config['connection']['database'],
        )
        
    def set_entities(self):
        self.server = Table(self.config['server']['name'], self.config['server']['columns'])
        self.wipe = Table(self.config['wipe']['name'], self.config['wipe']['columns'])
        self.player = Table(self.config['player']['name'], self.config['player']['columns'])
        self.thing = Table(self.config['thing']['name'], self.config['thing']['columns'])
        self.thing_in_request = Table(self.config['thing_in_request']['name'], self.config['thing_in_request']['columns'])
        self.request = Table(self.config['request']['name'], self.config['request']['columns'])
        self.request_status = Table(self.config['request_status']['name'], self.config['request_status']['columns'])
        self.discord_account = Table(self.config['discord_account']['name'], self.config['discord_account']['columns'])                    
    
    def load_config(self):
        with open(self.config_path, 'r') as f:
            self.config = json.load(f)
            
class Table:
    
    def __init__(self, table_name, columns):
        self.table_name = table_name
        self.columns = columns
        
class Connection:
    
    def __init__(self, host, user, password, database ):
        self.host = host
        self.user = user
        self.password = password
        self.database = database
        
    
        
        
    