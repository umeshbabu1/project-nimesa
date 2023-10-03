import requests
API_URL = "https://samples.openweathermap.org/data/2.5/forecast/hourly?q=London,us&appid=b6907d289e10d714a6e88b30761fae22"

def get_weather_data():

    response = requests.get(API_URL,verify=False)
    if response.status_code == 200:
        return response.json()
    else:
        print("Error fetching weather data. Please try again later.")
        return None
    


def print_weather_info(weather_data, date):
    for entry in weather_data['list']:
        if date in entry['dt_txt']:
            print(f"Temperature on {date}: {entry['main']['temp']}°C")
            return
    print(f"No weather data available for {date}.")
    


def print_wind_speed_info(weather_data, date):
    for entry in weather_data['list']:
        if date in entry['dt_txt']:
            print(f"Wind Speed on {date}: {entry['wind']['speed']} m/s")
            return
    print(f"No wind speed data available for {date}.")
    

def print_pressure_info(weather_data, date):
    for entry in weather_data['list']:
        if date in entry['dt_txt']:
            print(f"Pressure on {date}: {entry['main']['pressure']} hPa")
            return
    print(f"No pressure data available for {date}.")
    


weather_data = get_weather_data()
if not weather_data:
        print("0")
while True:
        print("Options:")1
        
        print("1. Get tempreture")
        print("2. Get Wind Speed")
        print("3. Get Pressure")
        print("0. Exit")
        option = int(input("Enter your choice: "))
        if option == 0:
            print("Terminating the program.")
            break
        elif option == 1:
            date = input("Enter the date (YYYY-MM-DD HH:MM:SS): ")
            print_weather_info(weather_data, date)
        elif option == 2:
            date = input("Enter the date (YYYY-MM-DD HH:MM:SS): ")
            print_wind_speed_info(weather_data, date)
        elif option == 3:
            date = input("Enter the date (YYYY-MM-DD HH:MM:SS): ")
            print_pressure_info(weather_data, date)
        else:
            print("Invalid option. Please try again.")