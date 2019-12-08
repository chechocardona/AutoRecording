#!/bin/bash

# Enable gpios
# Yellow LED, recording state
echo "16" > /sys/class/gpio/export
# Red LED, processing state // Press Button Confirmation 
echo "12" > /sys/class/gpio/export
# Play Button. Start Recording  // White Jumper
echo "13" > /sys/class/gpio/export
# Test Button: Record and Play during 3 seconds the selected microphone  // Blue Jumper 
echo "6" > /sys/class/gpio/export
# Increase Microphone Button: Change the selected microphone for the next one to test it // Purple Jumper 
echo "26" > /sys/class/gpio/export
# Stop Recording Switch: Stop recording once the current record and processing are finished // Brown Jumper
echo "7" > /sys/class/gpio/export
# Shut Down Button: Safe System shutdown // Orange Jumper
echo "11" > /sys/class/gpio/export

# Set In and Out Pins
sudo echo "out" > /sys/class/gpio/gpio16/direction
sudo echo "out" > /sys/class/gpio/gpio12/direction
sudo echo "in" > /sys/class/gpio/gpio13/direction
sudo echo "in" > /sys/class/gpio/gpio6/direction
sudo echo "in" > /sys/class/gpio/gpio26/direction
sudo echo "in" > /sys/class/gpio/gpio7/direction
sudo echo "in" > /sys/class/gpio/gpio11/direction
	
debug=0;
if [ $debug == "1" ]
then
	echo "Just Checking if started on boot";
else
	# Check if the sound card is recognized
	if ! arecord -l | grep 'List of CAPTURE Hardware Devices';
	then
		# Mount Sound Card
		sudo modprobe -r snd_soc_audioinjector_octo_soundcard;
		sudo modprobe -r snd_soc_cs42xx8_i2c;
		sudo modprobe -r snd_soc_cs42xx8;
		sudo modprobe snd_soc_cs42xx8;
		sudo modprobe snd_soc_cs42xx8_i2c;
		sudo modprobe snd_soc_audioinjector_octo_soundcard;
	fi
	sudo hwclock -s
	#export AUDIODEV=hw:0,0;
	#export AUDIODRIVER=alsa;
	mic=1;
	record=0;

	while [ 1=1 ]
	do
		c=$(cat /sys/class/gpio/gpio13/value)
		b=$(cat /sys/class/gpio/gpio6/value)
		d=$(cat /sys/class/gpio/gpio26/value)
		e=$(cat /sys/class/gpio/gpio7/value)
		f=$(cat /sys/class/gpio/gpio11/value)
		# Start continuous recording
		if [ $c == "1" ]
		then
			if [ $record=="0" ]	
			then
				let "record = 1"
				echo "1" > /sys/class/gpio/gpio12/value
				sleep 1s;
				echo "0" > /sys/class/gpio/gpio12/value
				echo "1" > /sys/class/gpio/gpio16/value
				name=$(date "+%Y.%m.%d-%H.%M.%S");
				mkdir /home/pi/TestDirection/"$name";
				nohup rec -c 6 /home/pi/TestDirection/"$name"/"$name"_%2n.flac trim 0 300 : newfile : restart > /dev/null & 
			fi
		fi
		# Start Test of current selected microphone
		if [ $b == "1" ]
		then
			if [ $record == "0" ]
			then
				echo "1" > /sys/class/gpio/gpio12/value
				sleep 1s;
				echo "0" > /sys/class/gpio/gpio12/value
	
				echo "1" > /sys/class/gpio/gpio16/value
				rec -c 6 /home/pi/TestDirection/test.wav trim 0 4;
				echo "0" > /sys/class/gpio/gpio16/value
				sox /home/pi/TestDirection/test.wav /home/pi/TestDirection/test1.wav remix $mic;
				aplay -D sysdefault:CARD=audioinjectoroc /home/pi/TestDirection/test1.wav;
				#sleep 5s;
				rm /home/pi/TestDirection/test.wav;
				rm /home/pi/TestDirection/test1.wav;
			fi
		fi
		# Change current selected microphone for the next one
		if [ $d == "1" ]
		then
			if [ $record == "0" ]
			then
				echo "1" > /sys/class/gpio/gpio12/value
				sleep 1s;
				echo "0" > /sys/class/gpio/gpio12/value
				if (( $mic < 6 ));		then
					let "mic += 1"
				else
					let "mic = 1"
				fi
				echo "$mic"
				#sleep 1s
			fi
		fi
		# Stop recording
		if [ $e == "1" ]
		then
			if [ $record=="1" ]
                        then
                                echo "1" > /sys/class/gpio/gpio12/value
                                sleep 1s;
                                echo "0" > /sys/class/gpio/gpio12/value
                                echo "0" > /sys/class/gpio/gpio16/value
                                pkill rec
                                let "record = 0"
                        fi

		fi
		# Safe System Shutdown
		if [ $f == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			sudo shutdown -h now 
		fi
	done
fi
