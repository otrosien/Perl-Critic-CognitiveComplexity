#!/bin/bash

set -e # Exit with nonzero exit code if anything fails

prove -j 3 -l -a testReport.tgz
cover -test -report clover
perlcritic --profile $TRAVIS_BUILD_DIR/.perlcriticrc --quiet --verbose "%f~|~%s~|~%l~|~%c~|~%m~|~%e~|~%p~||~%n" lib t > perlcritic_report.txt
sonar-scanner -Dsonar.host.url=http://sonarqube.racodond.com/
