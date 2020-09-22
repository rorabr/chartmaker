# chartmaker

Plot simpple, quick and dirty charts using 
[Chart](https://metacpan.org/pod/distribution/Chart/Chart.pod "Chart CPAN")
CPAN perl libraries. Data can be read from the command-line, stdin,
spreadsheets (xls, ods, csv and sxc), fixed file format or JSON.

## Features

* Simple and quick

* Read data from stdin, command-line, spreadsheets (xls, ods, csv and sxc), fixed file format or JSON

* Output to PNG or JPG

* Plot lines, points, linePoints, bars, XY, pie or histogram charts

* Based on the Chart::type CPAN perl modules

## License

This software is distributed under the MIT license. Please read
LICENSE for information on the software availability and distribution.

## Dependencies

* Perl 5 and Chart::type modules

## Instalation

Clone or download this repository and run `sudo make install`.

## Test and Examples

Run `make` inside the examples directory.

## Syntax

  `chartmaker [--geometry|g=WxH] [--width|x=W] [--height|y=H] [--output|o=file]
    [--format|f=png|jpg] [--delimiter|d=D] [--help|h] [--verbose|v]
    +option=value ... command ... `

Options and commands can be used more than once to change parameters for
reading file or plotting charts. Multiple files can be read in a single
run and multiple charts can be written as well. All commands and names
are case sensitive. When creating multiple charts in the same command one
must remember that the series (specially x) still exists between charts.

Options can have equal sign or space separating the value.

#### --geometry `width`x`height` OR -g=`width`x`height`

Specify the chart resolution in pixels. Geometry is width x height,
example: 1280x720. Default is 1920x1080.

#### --width `width` OR -x=`width`

Set only the chart's width, default is 1920.

#### --height `height` OR -y=`height`

Set only the chart's height, default is 1080.

#### --delimiter `delimiter` OR -d=`delimiter`

Set the dataset delimiter. Default is a comma (,). Can be a
single char or a string. The string {cr} specified a newline (\n)
and {space} specifies a space " ".

#### --output `file` OR -o=`file`

Set the output file. If the extension is not specified, .png or .jpg will
be added according to the file type. Default is chartmaker.png. If the output file is "-",
the chart will be written to stdout (can be redirected to a file).

#### --format `png`|`jpg` OR -f=`jpg`|`png`

Set the output file format to PNG or JPG. Default is PNG that
will produce a smaller lossless compression image.

#### --help OR -h

Show this help.

#### --verbose OR -v

Increase verbosity level. Essential to debug errors.

#### +option=value

Set a Chart::type option value like title, max and min values, etc. Numeric values don't need
quotes, but string values have to be quoted like "title".
Check the [Chart](https://metacpan.org/pod/distribution/Chart/Chart.pod "Chart CPAN")
CPAN perl documentation for complete information.

#### command

The following commands can be used in chartmaker:

##### name[(title)]=values

Define a new series named `name`, with the title `title` and values `values`.
The title is optional. If not informed, the title will be the name. The values
should be separated by the delimiter. Numbers can be integers or floats. If a
series is redefined the last definition will be used. The series will be
refered in the plot command by the "name". The x series, used to specify the
x labels in the chart can accept strings besides numbers.

##### name[(title)]=stdin

Define a new series reading values from stdin. Same rules apply.

##### name[(title)]=read("file")

Define a new series reading values from the text file "file". The last delimiter
will be used to parse the numbers.

##### name[(title)]=calc("file",rows|cols,Sheet'An:Bm,title|notitle)

Define a group of series called name\_title read from the spreadsheet
file. File could be openoffice, csv or excel. Rows indicate that
series are horizontal, cols indicate that series are vertical. The
coordinates indicate the cells containing values. If a series is
called "x", the prefix is not added and it becomes the X series,
otherwise the series name will be name\_title. The sheet name is optional.
Title and notitle specifies if the series name is present in the first
column/row. If not, series name will be name\_1, name\_2, etc.

##### name[(title)]=fixed("file",rows|cols,An:Bm,title|notitle,size,...)

Define e group of series called name\_title read from the fixed
column text file "file". rows indicate that series are horizontal, cols
indicate that series are vertical. The coordinates indicate the
cells containing values. Size are the size of each column in chars starting
at the first char. There are no delimiters.
Title and notitle specifies if the series name is present in the first
column/row. If not, series name will be name\_1, name\_2, etc.

##### name[(title)]=log(series)

Define a new series by calculating decimal logarythm of all
positive values of the series. Zero and negatives remain 0.

##### name[(title)]=histogram(series,buckets)

Define a new series by calculating it's histogram using buckets
number of buckets.

##### plot(series list)

Plot a chart and write the image to the output file (or stdout, if the output
filename is "-"). All series should be specified in the desired order by their
name in a list separated by commas.  The X labels will be read from a series
called "x" and does not have to included in the list. If the "x" series is not
defined, the labels will be integer numbers starting from 1.

## Config file

Chartmaker will try to read a JSON file from ~/.chartmaker and parse it as
default options. Example config file:

`{"width":1280, "height":720}`

## Options

All the options settings starting with + are well documented in the 
[Chart](https://metacpan.org/pod/distribution/Chart/Chart.pod "Chart CPAN")
CPAN page.

## Examples

`chartmaker y(Torque)=1.1,2.2,3.3,4.6,7.8 --output=test.png plot(y)`

Plot data from the command-line to test.png. The series name is Torque.

`uptime | perl -nae '($load) = $_ =~ /load average: (.*)/; print $load;' | ./chartmaker -g=512x320 --output=load --type=bars load=stdin x=5,10,15 +legend=\"none\" 'plot(load)'`

Plot the system load using bars in a small sized chart to load.png

`chartmaker -v --output=covid "covid=calc(\"example.xls\",rows,Countries'A1:H3)" +title=\"Covid19 in 2 Countries\" +precision=0 'plot(covid_brasil,covid_eua)' --output=milk --type=bars "milk=calc(\"example.xls\",cols,Milk'A1:D4)" +title=\"Milk in South America\" +precision=0 'plot(milk_1910,milk_1950,milk_1970)'`

Plot two charts with data extracted from the example.xls spreadsheet (two
different sheets named Countries and Milk. 

`chartmaker -v --output=json 'seq1(Sequence)=json("example.json",{sequence})' 'x=json("example.json",{x})'  'plot(seq1)'`

Plot a chart read from a JSON file. Two sequence of numbers are read from the
JSON file, seq1 and x (which are the X labels). The file is parsed only once
and is cached in memory. The second argument is the perl code to fetch data
from a perl hash without the variable name, i.e. $VAR1->{sequence}, or
$VAR1->[0], etc.

`chartmaker -t pie --output=webservers 'webservers(Web Servers Usage)=36.3,32.5,15.9,7.8,7.1,0.4' x=Apache,Nginx,Cloudflare,IIS,LiteSpeed,others 'plot(webservers)'`

Plot a piechart with the most used webservers. Sometimes quoting is necesary
to avoid shell expansion.


## Motivation

I know GNUplot exists. And it's the best ploting software there is. But every
time I want to plot something simple, to debug to just to visualize something,
I end up speding yours reading the GNUplot manual and checking examples on the
internet. That's why I wrote this.

## TODO

Improve testing, more examples. Options to change colors and fonts.

## Author

CmdlineApp class was developed by Rodrigo Antunes rorabr@github.com
Chart::type perl modules was developed by David Bonner (dbonner@cs.bu.edu)

