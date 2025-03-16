import time
import board
import adafruit_dht

# VE    - DHT version, e.g. 11 or 22
# PIN   - GPIO Pin the board is connected to, e.g. D4 = GPIO Pin 4
#                           VE       PIN
dhtDevice = adafruit_dht.DHT22(board.D4)
 
while True:
    try:
        # Print the values to the serial port
        temperature_c = dhtDevice.temperature
        temperature_f = temperature_c * (9 / 5) + 32
        humidity = dhtDevice.humidity
        print(  # Note: DHT11 only returns whole numbers
                # So the fraction is always 0
            "Temp: {:.1f} F / {:.1f} C    Humidity: {}% ".format(
                temperature_f, temperature_c, humidity
            )
        )
 
    except RuntimeError as error:
        # Sometimes you get errors, so just print them
        print(error.args[0])
        time.sleep(2.0)
        continue
    except Exception as error:
        dhtDevice.exit()
        raise error
 
    time.sleep(2.0)
