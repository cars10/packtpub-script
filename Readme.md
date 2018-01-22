# -NOT WORKING ANYMORE- The script should work again.
-Since packtpub introduced a captcha to receive the daily free ebook you can no longer use this script.-

# Automatically receive packtpub's free daily book
This script runs a headless browser, goes to `https://www.packtpub.com/packt/offers/free-learning`, logs into your account and "orders" the daily free book. After that it will send you an email with the title of the new book.

It's written in ruby and uses phantomjs to run a headless browser and do what was explained above.

## Setup
### What you need
* `ruby`. I recommend setting it up with [rvm](http://rvm.io/), but you can use your systems default ruby if you like.
* `phantomjs` >= `2.0`. Install via your systems packagemanager or download manually from their [website](http://phantomjs.org/). If you are using ubuntu you need to download it manually because the version in the ubuntu repos is a few years old. Try `phantomjs --version` to make sure that it's installed correctly.
* If you want to receive an email notification: a running `smtp server`, for example [postfix](https://wiki.ubuntuusers.de/Postfix/)

### Installation
Checkout the project
```bash
git clone https://github.com/cars10/packtpub-script
```

If you use rvm / rbenv: create your gemset. Skip if you use global ruby installation.

Install the dependencies 
```bash
# run inside the packtpub-script folder
gem install bundle
bundle install

# run with sudo if you use a global ruby installation instead of rvm / rbenv
```

### Configuration
You need to setup your packtpub credentials and the email adresses to send/receive the notification. To do so you have to create a file named `.env` inside the `packtpub-script` folder with the following contents:
```bash
PACKTPUB_EMAIL=your@mail.com
PACKTPUB_PASSWORD=yourPassword
SEND_NOTIFICATION=true
MAIL_RECEIVER=your@mail.com
MAIL_SENDER=smtp_sender@email.com
PHANTOMJS=/path/to/phantomjsBinary
```
To find out the path to the `phantomjs` binary, simply run `which phantomjs`.

## How to run the script
Run the script manually with
```bash
# inside the packtpub-script folder
ruby script.rb
```

Probably you want to run the script daily, so just setup a cron for that. Because cron does not use the same environment as your user this will not work out of the box, because ruby and/or rvm will not be available there. To work around this you can create a small bash script, i use the following:
```bash
#!/bin/bash
## Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"   

## source rvm so the gemset (and therefore ruby) is available.
# Make sure to adjust the path to the rvm binary: if you installed it as a user its in /home/<your_user>/.rvm/scripts/rvm .
# It will be different if you installed rvm with sudo rights
source /home/<your_user>/.rvm/scripts/rvm

## cd into the folder (to set the gemset) and run the script.
# you could also set the gemset manually and then run the script, for example:
# rvm gemset use <name_of_gemset> && ruby /path/to/folder/packtpub-script/script.rb
cd /path/to/folder/packtpub-script/ && ruby script.rb
```
Save the script, set permissions to allow execution with `sudo chmod +x script.sh` and setup a cronjob:
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
* the script times out before finding the necessary content/classes
    * Try to increase the timeout variable
    * Check you version of phantomjs, `phantomjs --version`. If it is lower then 2, update!
    * Check their website manually to see if they changed any classnames
* the script runs, but i do not get the new book:
    * If there are no error messages, try to insert `browser.screenshot.save 'screenshot.png'` anywhere in the script and check what went wrong.
* I receive the book but no notification
    * Check if you have setup the `.env` file correctly
    * Check if your smpt server is running and working

### Manual execution works, cron does not
Did you receive an error report from cron? Postfix should send you any errors via email automatically. If you did not receive an email, check your systems inbox, usally in `/var/mail/<user>` (or run the `mail` command). If you cannot find anything there either, check the system logs in `/var/log/syslog`, this is where cron logs anything (at least in a standard ubuntu system).

### Neither manual execution nor cron work
You either failed to setup `rvm`, the dependencies or `phantomjs`. Try to redo the steps in the setup or open an issue in this repo if you cannot get it working.

# TODO
* Send the actual book as an attachment in the mail
* Reduce dependencies, mabye switch from ruby to plain bash +js
* ~~Add more downloadlinks (mobi, epub)~~ done

# License
MIT

# Disclaimer
I am not related to packtpub in any way. All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.
