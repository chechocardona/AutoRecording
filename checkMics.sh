#!/bin/bash
if arecord -l | grep 'List of CAPTURE Hardware Devices';
then
	echo "16" > /sys/class/gpio/export
	echo "13" > /sys/class/gpio/export
	echo "12" > /sys/class/gpio/export
	echo "6" > /sys/class/gpio/export
	echo "26" > /sys/class/gpio/export
	echo "7" > /sys/class/gpio/export
	echo "11" > /sys/class/gpio/export
	
	sudo echo "out" > /sys/class/gpio/gpio16/direction
	sudo echo "out" > /sys/class/gpio/gpio12/direction
	sudo echo "in" > /sys/class/gpio/gpio13/direction
	sudo echo "in" > /sys/class/gpio/gpio6/direction
	sudo echo "in" > /sys/class/gpio/gpio26/direction
	sudo echo "in" > /sys/class/gpio/gpio7/direction
	sudo echo "in" > /sys/class/gpio/gpio11/direction
	export AUDIODEV=hw:0,0;
	export AUDIODRIVER=alsa;
	mic=1;
	record=0;

	while [ 1=1 ]
	do
		c=$(cat /sys/class/gpio/gpio13/value)
		b=$(cat /sys/class/gpio/gpio6/value)
		d=$(cat /sys/class/gpio/gpio26/value)
		e=$(cat /sys/class/gpio/gpio7/value)
		f=$(cat /sys/class/gpio/gpio11/value)
		if [ $c == "1" ]
		then
			let "record = 0"
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			while [ $record == "0" ]
			do
				echo "1" > /sys/class/gpio/gpio16/value
				name=$(date "+%Y.%m.%d-%H.%M.%S");
				rec /home/pi/TestDirection/recsome.wav trim 0 300;
				echo "0" > /sys/class/gpio/gpio16/value
				echo "1" > /sys/class/gpio/gpio12/value
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_1.mp3 remix 1;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_2.mp3 remix 2;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_3.mp3 remix 3;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_4.mp3 remix 4;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_5.mp3 remix 5;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_6.mp3 remix 6;
				echo "0" > /sys/class/gpio/gpio12/value
				e=$(cat /sys/class/gpio/gpio7/value)
				if [ $e == "1" ]
				then
					echo "1" > /sys/class/gpio/gpio12/value
					sleep 1s;
					echo "0" > /sys/class/gpio/gpio12/value
					let "record=1"
				fi
				#sleep 5m;
			done
		fi
		if [ $b == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value

			echo "1" > /sys/class/gpio/gpio16/value
			rec /home/pi/TestDirection/test.wav trim 0 4;
			echo "0" > /sys/class/gpio/gpio16/value
			sox /home/pi/TestDirection/test.wav /home/pi/TestDirection/t.wav remix $mic;
			aplay -D sysdefault:CARD=audioinjectoroc /home/pi/TestDirection/t.wav
		fi
		if [ $d == "1" ]
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
			sleep 1s
		fi
		if [ $e == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			let "record=1"
		fi
		if [ $f == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			sudo shutdown -h now 
		fi
	done

else
	echo "16" > /sys/class/gpio/export
	echo "13" > /sys/class/gpio/export
	echo "12" > /sys/class/gpio/export
	echo "6" > /sys/class/gpio/export
	echo "26" > /sys/class/gpio/export
	echo "7" > /sys/class/gpio/export
	echo "11" > /sys/class/gpio/export

	sudo echo "out" > /sys/class/gpio/gpio16/direction
	sudo echo "out" > /sys/class/gpio/gpio12/direction
	sudo echo "in" > /sys/class/gpio/gpio13/direction
	sudo echo "in" > /sys/class/gpio/gpio6/direction
	sudo echo "in" > /sys/class/gpio/gpio26/direction
	sudo echo "in" > /sys/class/gpio/gpio7/direction
	sudo echo "in" > /sys/class/gpio/gpio11/direction

 	sudo modprobe -r snd_soc_audioinjector_octo_soundcard;
	sudo modprobe -r snd_soc_cs42xx8_i2c;
	sudo modprobe -r snd_soc_cs42xx8;
	sudo modprobe snd_soc_cs42xx8;
	sudo modprobe snd_soc_cs42xx8_i2c;
	sudo modprobe snd_soc_audioinjector_octo_soundcard;
	export AUDIODEV=hw:0,0;
	export AUDIODRIVER=alsa;
	mic=1;
	record=0;

	while [ 1=1 ]
	do
		c=$(cat /sys/class/gpio/gpio13/value)
		b=$(cat /sys/class/gpio/gpio6/value)
		d=$(cat /sys/class/gpio/gpio26/value)
		e=$(cat /sys/class/gpio/gpio7/value)
		f=$(cat /sys/class/gpio/gpio11/value)
		if [ $c == "1" ]
		then
			let "record = 0"
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			while [ $record == "0" ]
			do
				echo "1" > /sys/class/gpio/gpio16/value
				name=$(date "+%Y.%m.%d-%H.%M.%S");
				rec /home/pi/TestDirection/recsome.wav trim 0 300;
				echo "0" > /sys/class/gpio/gpio16/value
				echo "1" > /sys/class/gpio/gpio12/value
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_1.mp3 remix 1;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_2.mp3 remix 2;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_3.mp3 remix 3;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_4.mp3 remix 4;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_5.mp3 remix 5;
				sox /home/pi/TestDirection/recsome.wav /home/pi/TestDirection/"$name"_6.mp3 remix 6;
				echo "0" > /sys/class/gpio/gpio12/value
				e=$(cat /sys/class/gpio/gpio7/value)
				if [ $e == "1" ]
				then
					echo "1" > /sys/class/gpio/gpio12/value
					sleep 1s;
					echo "0" > /sys/class/gpio/gpio12/value
					let "record=1"
				fi
				#sleep 5m;
			done
		fi
		if [ $b == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			echo "1" > /sys/class/gpio/gpio16/value
			rec /home/pi/TestDirection/test.wav trim 0 4;
			echo "0" > /sys/class/gpio/gpio16/value
			sox /home/pi/TestDirection/test.wav /home/pi/TestDirection/t.wav remix $mic;
			aplay -D sysdefault:CARD=audioinjectoroc /home/pi/TestDirection/t.wav
		fi
		if [ $d == "1" ]
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
			sleep 1s
		fi
		if [ $e == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			let "record=1"
		fi
		if [ $f == "1" ]
		then
			echo "1" > /sys/class/gpio/gpio12/value
			sleep 1s;
			echo "0" > /sys/class/gpio/gpio12/value
			sudo shutdown -h now 
		fi
	done
fi
