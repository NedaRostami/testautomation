## Last Test Status on Grid Server and Jenkins ###

![Grid Test Status](https://badges.herokuapp.com/browsers?googlechrome=74&firefox=66&android=8.1&versionDivider=true&labels=longName)
![Grid Test Status](https://badges.herokuapp.com/browsers?android=8.1.1&versionDivider=true)
### ROBOT FRAMEWORK ###

Robot Framework is a generic test automation framework for acceptance testing and acceptance test-driven development (ATDD). It has easy-to-use tabular test data syntax and it utilizes the keyword-driven testing approach.

 Its testing capabilities can be extended by test libraries implemented either with Python or Java, and users can create new higher-level keywords from existing ones using the same syntax that is used for creating test cases.
Robot Framework project is hosted on GitHub where you can find further documentation, source code, and issue tracker.

 Downloads are hosted at PyPI. The framework has a rich ecosystem around it consisting of various generic test libraries and tools that are developed as separate projects.

Robot Framework is operating system and application independent. The core framework is implemented using Python and runs also on Jython (JVM) and IronPython (.NET).

Robot Framework itself is open source software released under Apache License 2.0, and most of the libraries and tools in the ecosystem are also open source. The framework was initially developed at Nokia Networks and it is nowadays sponsored by Robot Framework Foundation.  


### JENKINS SERVER REQUIREMENTS ###
-	Python libraries:
     - apt-get install gcc libpq-dev -y
     - apt-get install python-dev  python-pip -y
     - apt-get install python3-dev python3-pip python3-venv python3-wheel -y
     - pip3 install wheel
     -	pip install -r requirements.txt

-	Jenkins plugins:
     -	Robot Framework Plugin
     -	Build Name Setter Plugin
- Python Hacks
   -  /usr/local/lib/python2.7/dist-packages/faker/providers/lorem/fa_IR/__init__.py

### SETUP JENKINS ACCEPTANCE-WEB-PR JOB ###

-	setup parameters:
      -	trumpet_prenv_id  (staging)
      -	backendChanged  (Boolean)
      -	file_url (http://trumpetbuild.mielse.com:8001/Sheypoor-Stable-2.4.0.apk)
      -	file_version (2.4.0)
      -	REMOTE_TEST (choice parameter :  Grid)
      -	Logs (Reports)
      -	pivotal_story
-	set github project as https://github.com/sheypoor/auto-tests/
-	set Credentials of git
-	set build name: #${BUILD_NUMBER}-PR-${trumpet_prenv_id}
-	set up Jenkins Job to run shell of pabot as : bash All.sh
-	setup robot framework plugin for Jenkins:
-	Directory of Robot output:  Reports
-	Thresholds: 80100
-	set post build to robot framework and set parameters with Wildcard for output like :
     -	**/output*.xml  
     -	**/*report.html
     -	**/*log.html
     -	**/*.png
-	Post build: bash postBuild.
- set java_args -Dhudson.model.DirectoryBrowserSupport.CSP=false in /etc/default/jenkins


### ACCEPTANCE.YAML ###
The above setting can be used quickly by this Yaml in utils/acceptance.yaml:

- https://github.com/sheypoor/auto-tests/blob/master/utils/acceptance.yaml

### SETUP HOST SERVER  ###
1.	Build  Ubuntu Xenial 16.04 (LTS) and ssh to it
2.	curl -fsSL get.docker.com -o get-docker.sh
     - sh get-docker.sh
3.	install compose :
     -  apt install python-pip
     -	pip install --upgrade pip
     -	pip install docker-compose

### INSTALLATION OF Selenium Grid ###

1.	docker pull elgalu/selenium
2.	mkdir -p /home/grid
3.	cd  /home/grid
4.	upload docker-compose.yaml
5.	docker-compose up --force-recreate

nano/etc/systemd/system/selenium_grid.service


[Unit]
Description=Seleneium Grid

[Service]
WorkingDirectory=/home/grid
ExecStart=/usr/local/bin/docker-compose up --force-recreate
Restart=no

[Install]
WantedBy=multi-user.target

chmod +x  /etc/systemd/system/selenium_grid.service
systemctl enable selenium_grid.service
systemctl start selenium_grid.service
systemctl status selenium_grid.service
systemctl daemon-reload
systemctl restart selenium_grid.service

### DOCKER-COMPOSE.YAML ###

- https://github.com/sheypoor/auto-tests/blob/master/utils/docker-compose.yaml


### TESTS STRUCTURE ###

- All tests in auto-tests on github as the following directories:
      - Mobile
      - Web
      - Android
- Lib
      - All custom python libraries
- Utils
      - All config and backups
- Vars
      - All variable files
- Bash files to run tests and send pivotal comments
      - All.sh
      - postBuild.sh
      - Android_App.sh
      - Lunch_test_and_rerun.sh

### ROBOT FRAMEWORKS COMMAND DESCRIPTION ###

Here is an example of command line of RF and its description:

pabot  --processes 8 -P ./lib/ -d  $logs  -A ./vars/ch.txt  -o output_first_run.xml -l first_run_log.html -r first_run_report.html  ./web/desktop.tests

-	pabot  
     -	Parallel executor for Robot Framework test cases.
-	--processes 8
     -	Maximum concurrent test is set to 8
-	-P ./lib/
     -	Set python path to lib dir
-	-d  $logs  
     -	Set output directory for logs and screenshots to env var $logs (Reports)
-	-A ./vars/ch.txt  
     -	Set variable file to chrome to test chrome
-	-o  output_first_run.xml  -l  first_run_log.html  -r  first_run_report.html  
     -	Set xml, report and log file names
-	./web/desktop.tests
     -	Run all tests in the web/desktop.tests directory and all the sub-dirs  (.robot files)

### HOW IT WORK? ###

1.	Jenkins acceptance job will be auto build by parent job web-pr
2.	It will delete workspace
3.	Jenkins get latest repository from GitHub .
4.	run All.sh .  it will call another bash file which will run web tests and rerun failed tests based on condition of failure at Selenium Grid server (polsrv07.mielse.com)
5.	All test session will be recorded if recording has been set to true in docker-compose
6.	All test logs will be generated and will be merged if rerun has been occurred
7.	Link to SG video file will be set on log file metadata
8.	bash then run App tests and Mobile Web on Grid Server if it is necessary (backendChanged and web test success percentage )
9.	link to test log and video will be set on log file metadata
10.	Jenkins RF plugin  will calculate test result success ( Thresholds ). Save log files in job history
11.	postBuild.sh after all done will comment the related brief test results on Pivotal story


### PROJECT REPOSITORY ###
https://github.com/sheypoor/auto-tests

### CONTRIBUTING ###
1.	Create a fork of this repository
2.	Clone your fork
3.	Add projectcosta as remote: git remote add sheypoor git@github.com:sheypoor/auto-tests.git
4.	Create a branch for your assignment git checkout -b add-feature-x
5.	Change stuff
6.	Add and commit changes git add foo.yaml ; git commit -m "foo.yaml is great stuff"
7.	your branch to your fork git push origin add-feature-x
8.	Go to https://github.com/sheypoor/auto-tests and click the green button in the yellow field to create a Pull Request When pull request is merged - update your forks master branch git checkout master ; git pull --ff-only sheypoor master
9.	(Optional) delete your branch git branch -d add-feature-x ; git push origin :add-feature-x (If you want to continue working on the branch, you must update it git pull --ff-only sheypoor master)

### REFRENCES ###
-	https://github.com/robotframework/robotframework
- http://robotframework.org/robotframework/#user-guide
-	https://github.com/robotframework/SeleniumLibrary
-	https://github.com/mkorpela/pabot
- https://zalando.github.io/zalenium/
- http://appium.io/
- https://sites.google.com/a/chromium.org/chromedriver/
- https://github.com/butomo1989/docker-android
-	https://github.com/serhatbolsu/robotframework-appiumlibrary
-	https://wiki.jenkins-ci.org/display/JENKINS/Robot+Framework+Plugin
-	https://wiki.jenkins-ci.org/display/JENKINS/Build+Name+Setter+Plugin
-	https://github.com/eviltester/startUsingSeleniumWebDriver


# Pivotal filtering for Test team : #

### Uncomplete ###
 (state:finished AND -label:devops AND -label:automatic_test AND -label:qa AND (-label:codereviewed   OR  (-label:description_test notest overalltest overall api_test))) OR state:rejected

### Done ###
(-label:qa AND state:finished AND (label:description* OR label:notest  OR label:overall* OR label:feature_test OR api_test) AND (label:codereview* OR label:ios)) OR (type:release AND state:unstarted AND label:release AND label:android)

### Tested & delivered ####
label:qa AND -state:accepted  AND  -label:deployed


### No QA ####
state:accepted,delivered AND -label:qa  AND -label:devops AND -label:design
-label:qa  AND -label:devops AND -label:design AND -label:automatic_test AND state:accepted,delivered includedone:false

# Tests Scenarios #

# Android APP #

- Add New Listing in car
- Add New Listing in real estate
- Car filtering
- Login register by email
- Login register by mobile
- Toolbar menu links
- My account
- Category and location filter
- Search app
- Landscape and portrait listing view
- Chat (login first or last)
- favorite
- Reporting
- Image full size view
- Share listing
- Contact Support (login first or last)
- Send Bug message
- Share Sheypoor APP
- Sheypoor Rules
- Call Support
- Check Notifications
- Swipe listing 100 times  
- scroll Serp 1000 listing
- Save Search


# Web site #

## Login ##
- Login register by email / mobile

## Post Listing ##
- Add listing in music category by user not registered first and register by email / Mobile
- Add Listing in furniture /  car /  Real estate / Mobile
- Add listing by user registered first
- Add listing with max / min / no images
- Accept, expire, delete and reject listing
- Add listing with no image  reject listing  edit listing by add image  check admin db.listing error and image function
- clear post listing Form
- come back to unfinished post listing
- Image assertion
- Edit listing

## Interaction ##
- My listing functionality
- favorite and unfavorite
- Sharing listing
- Report Listing
- Edit Listing many times

## My Account ##
- My listing
- favorite / unfavorite
- my saved search

## Listing Details ##
- next and previous in listing details
- Mobile Number Visibility in Contact
- Mobile Number Visibility in description
- Breadcrumbs
- Check images

## SERP ##
- gallery view
- Check All regions links and by svg on map
- Check All cat and Subcats Links on serp  and validate (get cat list from API)
- Search for some keywords
- Sort price  

## Search and filtering ##
- Save Search
- filter Real Estate /car / Mobile
- by keywords

## Bumping ##
- By coupon
- without coupon
- successful and Unsuccessful payment

## Save Search ##
- Add /edit /delete
- My saved search

## Moderation ##
- Admin overall
- Admin links
- Admin approve performance
- Search by ID
- confirm Listing
- moderation history

## functionality ##
- Check header response of logo, JS, image and Serp for cache HIT and MISS
- Check the JsUnit test result
- AMP

## Shop ##
- Create shop
- Post listing in shop
- Validate shop details
- Search shop
- Shop packages
- Special Ads

# Mobile Site #

- Login register by email
- Login register by mobile
- Add listing in music category by user not registered first and register by email
- Add listing in music category by user not registered first and register by mobile
- Add listing by user registered first
- Add listing with max images
- Add listing with min images
- Add listing with no images
- Accept, expire, delete and reject listing
- My listing functionality

# Api #

Available on 3.0.2 - 3.0.3 - 3.0.4 - 3.0.5 - 3.1.0 - 3.1.1

# ProTools Api #

Available on Version 1
- Authentication
- Profile
- File/Listing Actions
- Config
- Upload Image
- Shop
- Team

#### General ####
- App version
- Categories
- Complaint
- Feedback
- Locations
- Static data
- Static data version
- Config
- Features data
- iOS fake app

#### User ####
- User authentication
- Auth authentication
- Resend verification code
- Logout
- Saved search


#### Listings ####
- Post listing
- Edit listing
- Delete listing
- My listings
- My listing Details
- Serp listings
- Serp listing Details
- Get listing number
- Get listing description
- Location auto detect (once available in PRs)
- Favorite listing
- My favorites
- Renew listing (should return error)
- Related listings
- Report listing
- Contact listing user

# Smoke Test #
- Homepage
- Serp
- Contact support
- Login page
- Post listing page
- Verification code mock
- Static data version

cloc $(git ls-files)
