#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT service_id,name FROM services")

echo -e "\n~~ BARBER SHOP STREKOZA ~~"

LOGIN(){
  echo -e "\nEnter your phone number please:"
  read CUSTOMER_PHONE
  NAME_CHECK=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $NAME_CHECK ]]
  then
  echo -e "\nTell us you name please:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi 
  echo -e "\nType the time in 'hh:mm' format you want to schedule for:"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME_FINAL=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\n$CUSTOMER_ID"
  INSERTED_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$1,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a$2 at $SERVICE_TIME,$CUSTOMER_NAME_FINAL."
}

MAIN_MENU(){
echo -e "\nPlease select a service you want to sign for:"
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
echo  "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
echo -e "\nThe service you picked does not exist."
MAIN_MENU
else
SERVICE_NAME_CHECK=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME_CHECK ]]
then
echo -e "\nService you chose does not exist"
MAIN_MENU
else 
echo -e "\nYou chose $SERVICE_NAME_CHECK"
LOGIN $SERVICE_ID_SELECTED "$SERVICE_NAME_CHECK"
fi
fi
}
MAIN_MENU


