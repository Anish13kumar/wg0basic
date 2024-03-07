#!/usr/bin/python3

import os,subprocess

name = input("Enter Peer Name: ")
cm = subprocess.run(['./add-client.sh',f'{name}'],input=os.environ.get('pass'),shell=False)
subprocess.run(['./restart.sh'],input=os.environ.get('pass'),shell=False)

if cm.returncode == 0:
    print("Client Added Successfully!")
else:
    print(f"Process Exited With Returncode {cm.returncode}")
