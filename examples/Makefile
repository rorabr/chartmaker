# Makefile to generate all chartmaker example charts - RORA - BH - 2020-09-20

PRG=perl ../chartmaker
OPT=--geometry=1280x720 +sub_title=\"by chartmaker\" +y_grid_lines=1
TARGET=webservers.png global_temp.png load.png Qtrly-Spoken-Language.png co2_mm_mlo.png meteorite-landings.png happiness.png covid19_deaths_global.png

all: $(TARGET)

# Pie chart example with data specified in the command-line:
# source: https://w3techs.com/technologies/overview/web_server
webservers.png: webservers.txt
	$(PRG) $(OPT) --type Pie --output=$@ '+title="Web Servers Usage"' x=Apache,Nginx,Cloudflare,IIS,LiteSpeed,others --delimiter={cr} 'webservers(Web Servers Usage)=file("webservers.txt")' 'plot(webservers)'

# Line chart example with data read from a xls spreadsheet:
# source: https://climate.nasa.gov/vital-signs/global-temperature/
global_temp.png: global_temp.xls
	$(PRG) $(OPT) -o $@ --type=LinesPoints "temp=calc(\"global_temp.xls\",cols,Global_temp'A76:C145,notitle)" '+x_label="Year"' '+y_label="Temperature variation (C)"' '+legend="none"' +min_y_ticks=5 +precision=1 x=\@temp_1 'plot(temp_2)'

# Bar chart example showing the system load from the uptime system tool:
load.png: Makefile
	uptime | perl -nae '($$load) = $$_ =~ /load average: (.*)/; print $$load;' | $(PRG) $(OPT) --output=$@ --type=Bars load=stdin x=5,10,15 +legend=\"none\" '+title="System load"' 'plot(load)'

# Pie chart example reading data from a CSV file:
# source: https://catalog.data.gov/dataset/social-security-administration-quarterly-data-for-spoken-language-preferences-of-supplemen-6d08a
Qtrly-Spoken-Language.png: Qtrly-Spoken-Language.csv
	$(PRG) $(OPT) --type Pie -o $@ "lang=calc(\"Qtrly-Spoken-Language.csv\",cols,A6:B40,notitle)" x=@lang_1 '+legend="none"' 'plot(lang_2)'

# Bar chart example reading data from a fixed sized columns file:
# source: https://climate.nasa.gov/vital-signs/carbon-dioxide/
co2_mm_mlo.png: co2_mm_mlo.txt.gz
	gunzip -c co2_mm_mlo.txt.gz | grep -v '^#' | grep '  12  ' | $(PRG) $(OPT) -t Bars --output $@ 'co2=fixed("stdin",cols,A25:F62,notitle,4,4,12,12,12,12,7)' 'x=@co2_1' 'emissions(CO2 in ppm)=@co2_6' +precision=0 '+title="Monthly CO2 emissions - source: NOAA"' '+label_values="none"' 'plot(emissions)'

# XY point chart example reading data from a JSON using loop iteration
# source: https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh
meteorite-landings.png: meteorite-landings.json
	$(PRG) $(OPT) --type=Points -o=$@ "long=json(\"meteorite-landings.json\",[]->{reclong})" "lat=json(\"meteorite-landings.json\",[]->{reclat})" +xy_plot=1 '+x_label="Longitude"' '+y_label="Latitude"' '+legend="none"' 'plot(long,lat)'

# Histogram chart example reading data from a CSV file and grouping into 16 bins
# source: https://www.kaggle.com/unsdsn/world-happiness
happiness.png: happiness.csv
	$(PRG) $(OPT) --type=Bars --output=$@ "data=calc(\"happiness.csv\",cols,B2:G157,notitle)" 'lifeexpect(Years)=histogram(data_6,16)' 'x=@lifeexpect_x' +precision=0 '+legend="none"' '+title="Life Expectancy distribution by number of countries"' '+x_label="Years"' 'plot(lifeexpect)'

# Logarythmic scale chart example reading data from STDIN
# source: JHU @ github: https://github.com/CSSEGISandData/COVID-19
covid19_deaths_global.png: covid19_deaths_global.csv.gz
	gunzip -c covid19_deaths_global.csv.gz | grep -E '(Country\/Region|Brazil|US|India|Mexico)' | $(PRG) $(OPT) --output $@ "d(Covid19 deaths)=calc(\"stdin:csv\",rows,B1:IL5,title)" 'us(US)=log(d_US)' 'brazil(Brazil)=log(d_Brazil)' 'india(India)=log(d_India)' 'mexico(Mexico)=log(d_Mexico)' 'x=@d_CountryRegion' +min_val=0 +skip_x_ticks=11 +precision=0 '+y_label="Deaths (log)"' '+title="Covid19 deaths in top 4 worst countries - source: JHU"' 'plot(us,brazil,india,mexico)'

clean:
	rm $(TARGET)
