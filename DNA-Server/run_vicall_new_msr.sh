cd /home/dave/dynanet/
rm newly_completed.txt
touch newly_completed.txt
for FILE in import/VICSCN*msr.xml
do
 FILENAME=${FILE:7:13}

if grep -Fxq "$FILENAME" completed.txt
then
    # code if found
	echo "$FILENAME Processed"
else
    # code if not found
	echo "$FILENAME Not Processed"
	STN="${FILENAME}stn.xml"
	MSR="${FILENAME}msr.xml"
	FULL="${FILENAME}-FULL"
	GNSS="${FILENAME}-GNSS"
	CONTROL="VICControl${FILE:13:21}"
	FULLMSR="${FILENAME}-FULLmsr.xml"
	FULLSTN="${FILENAME}-FULLstn.xml"


##Full Adjustment
# 1. import the data
echo "dnaimport -o vicscnadj -n $FULL $STN $MSR $CONTROL -i import --search-sim --ignore-sim --remove-ign --export-xml"
dnaimport -o vicscnadj -n $FULL $STN $MSR $CONTROL -i import --search-sim --ignore-sim --remove-ign --export-xml

# 2. Interpolate ellipsoid-geoid seprations to reduce sttion heights to the ellipsoid
echo "dnageoid vicscnadj/$FULL -g import/AUSGeoid09.gsb --convert"
dnageoid vicscnadj/$FULL -g import/AUSGeoid09.gsb --convert

# 3. Segment the network
echo "dnasegment vicscnadj/$FULL --min 400 --max 450"
dnasegment vicscnadj/$FULL --min 400 --max 450

# 4. Adjust the network using multi-thread mode, sort on nstat
echo "dnaadjust vicscnadj/$FULL --multi --output-adj-msr --sort-adj-m 7 --output-pos --output-cor --stn-coord-types "PLhHENz" --hz-corr 0.2 --export-xml --output-msr-to-stn"
dnaadjust vicscnadj/$FULL --multi --output-adj-msr --sort-adj-m 7 --output-pos --output-cor --stn-coord-types "PLhHENz" --hz-corr 0.2 --export-xml --output-msr-to-stn

sed -i '8i<DnaMeasurement></DnaMeasurement>' $FULLMSR

#curl to push to DB servers go here..



rm vicscnadj/$FULL*

##GNSS Only Adjustment
# 1. import the data
echo "dnaimport -o vicscnadj -n $GNSS  $STN $MSR $CONTROL -i import --search-sim --ignore-sim --remove-ign --include-msr-types GXY"
dnaimport -o vicscnadj -n $GNSS $STN $MSR $CONTROL -i import --search-sim --ignore-sim --remove-ign  --include-msr-types GXY

# 2. Interpolate ellipsoid-geoid seprations to reduce sttion heights to the ellipsoid
echo "dnageoid vicscnadj/$GNSS -g import/AUSGeoid09.gsb --convert"
dnageoid vicscnadj/$GNSS -g import/AUSGeoid09.gsb --convert

# 3. Segment the network
echo "dnasegment vicscnadj/$GNSS --min 400 --max 450"
dnasegment vicscnadj/$GNSS --min 400 --max 450

# 4. Adjust the network using multi-thread mode, sort on nstat
echo "dnaadjust vicscnadj/$GNSS --multi --output-adj-msr --sort-adj-m 7 --output-pos --output-cor --stn-coord-types "PLhHENz" --hz-corr 0.2 --export-xml --output-msr-to-stn"
dnaadjust vicscnadj/$GNSS --multi --output-adj-msr --sort-adj-m 7 --output-pos --output-cor --stn-coord-types "PLhHENz" --hz-corr 0.2 --export-xml --output-msr-to-stn

#curl to push to DB servers go here..
rm vicscnadj/$GNSS*


echo $FILENAME>>newly_completed.txt
echo $FILENAME>>completed.txt



fi
done
#curl to push to DB servers go here..
