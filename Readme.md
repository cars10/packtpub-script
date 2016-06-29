# Automatically receive packtpub's free daily book
This script runs a headless browser, goes to `https://www.packtpub.com/`, logs into your account and "orders" the daily free book. After that it will send you an email with the title of the new book.

It's written in ruby and uses phantomjs to run a headless browser and do what was explained above.

## Setup
### What you need
* `ruby`. I recommend setting it up with [rvm](http://rvm.io/)
* `phantomjs`. Install via your systems packagemanager or download manually from their [website](http://phantomjs.org/)
* If you want to receive an email notification: a running `smtp server`, for example [postfix](https://wiki.ubuntuusers.de/Postfix/)

### Installation
Checkout the project
```bash
cd /some/folder
git clone https://github.com/cars10/packtpub-script
```

If you use rvm (you should use rvm or rbenv), create `.ruby-version` and `.ruby-gemset`
```bash
cd packtpub-script
echo ruby-2.3.0 > .ruby-version
echo packtpub-script > .ruby-gemset # you can name the gemset whatever you like
```

Create the gemset
```bash
cd ..
cd packtpub-script
```

Install the dependencies
```bash
# run inside the packtpub-script folder
gem install bundle
bundle install
```

### Configuration
You need to setup your credentials and the emails to send/receive the notifiaction. To do so you have to create a file named `.env` inside the `packtpub-script` folder with the following contents:
```bash
PACKTPUB_EMAIL=your@mail.com
PACKTPUB_PASSWORD=yourPassword
SEND_NOTIFICATION=true
MAIL_RECEIVER=your@mail.com
MAIL_SENDER=smtp_sender@email.com
PHANTOMJS=/path/to/phantomjsBinary
```
To find out the path to the `phantomjs` binary, simply run `whereis phantomjs` if you installed it.

## How to run the script
Run the script manually with
```bash
# inside the packtpub-script folder
ruby script.rb
```

Probably you want to run the script daily, so just setup a cron for that. Because cron uses a different environment then your user this will not work out of the box, because ruby and/or rvm will not be available there. To work around this you can create a small bash script, i use the following:
```bash
#!/bin/bash
## Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"   

## source rvm so the gemset (and therefore ruby) is available.
# Make sure to adjust the path to the rvm binary: if you installed it as a user its in /home/<your_user>/.rvm/scripts/rvm . It will be different if you installed rvm with sudo rights
source /home/<your_user>/.rvm/scripts/rvm

## cd into the folder (to set the gemset) and run the script.
# you could also set the gemset manually and then run the script, for example:
# rvm gemset use <name_of_gemset> && ruby /path/to/folder/packtpub-script/script.rb
cd /path/to/folder/packtpub-script/ && ruby script.rb
```
Save the script, set permissions to allow execution, `sudo chmod +x script.sh` and setup a cronjob:
```bash
crontab -e
```
To run daily at 04:00 am:
```
0 4 * * * /path/to/script.sh
```

## Troubleshooting
If the script/your cron does not work, first of all try to run the script manually with `ruby script.rb`.

### Cron / manual execution basically works, but...
* Script times our before finding the necessary content/classes
    * Try to increase the timeout variable
    * Check their website manually to see if they changed any classnames
* Script runs throught, but i do not get the new book:
    * If there are no error messages, try to insert `browser.screenshot.save 'screenshot.png'` anywhere in the script and check what wents wrong.
* I receive the book but no notification
    * Check if you have setup the `.env` file correctly
    * Check if postfix is running and working 

### Manual execution works, cron does not
Did you receive an error report from cron? Postfix should send you any errors via email automatically. If you did not receive an email, check your systems inbox, usally in `/var/mail/<user>` (or run the `mail` command). If you cannot find anything there either, check the system logs in `/var/log/syslog`, this is where cron logs anything (at least in a standard ubuntu system).

### Neither manual execution nor cron work
You either failed to setup `rvm` or `phantomjs`. Try to redo the steps in the setup or open an issue in this repo if you cannot get it working.

# License
MIT

# Disclaimer
I am not related to packtpub in any way. All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.
