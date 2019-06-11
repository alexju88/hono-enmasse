#Create a tenant
curl -X POST -i -H 'Content-Type: application/json' -d '{"tenant-id": "ditto"}' https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/tenant

#validate
curl -i https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/tenant/ditto

#Register a device
curl -X POST -i -H 'Content-Type: application/json' -d '{"device-id": "car"}' https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/registration/ditto

#validate
curl -i https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/registration/ditto/car

#Add a device credential
PWD_HASH=$(echo -n 'car-password' | openssl dgst -binary -sha512 | base64 -w 0)
curl -X POST -i -H 'Content-Type: application/json' -d '{"device-id": "car","type": "hashed-password","auth-id": "car-auth","secrets": [{"hash-function" : "sha-512","pwd-hash": "'$PWD_HASH'"}]}' https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/credentials/ditto

#look credentials
curl -i https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/credentials/ditto/car
#delete credentials
curl -i -X DELETE https://hono-test.bosch-iot-suite.market.huaweicloud.com:31080/credentials/ditto/car/hashed-password

#Publish data,publish telemetry (or also event) data via the Hono HTTP adapter:
curl -X POST -i -u car-auth@ditto:car-password -H 'Content-Type: application/json' -d '{"temp": 23.07,"hum": 45.85}' https://hono-test.bosch-iot-suite.market.huaweicloud.com:30080/telemetry





#you can also publish telemetry data via MQTT:
mosquitto_pub -u 'car-auth@ditto' -P car-password -t telemetry -m '{"temp": 23.07}'  -h 192.168.0.92 -p 31883
mosquitto_pub -u 'car-auth@ditto' -P car-password -t telemetry -m '{"hum": 45.85}'  -h 192.168.0.92 -p 31883
mosquitto_pub -u 'car-auth@ditto' -P car-password -t telemetry -m 'hello'  -h 192.168.0.92 -p 31883
