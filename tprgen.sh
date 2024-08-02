#!/bin/bash

function tprtext(){
    echo "###############################"
    echo " TPR Text Analyzer"
    echo "###############################"
    echo "$ ./tprtext.sh [option1] [TPR]"
    echo "-----------------------------"
    echo " usage: ./tprtext.sh -sql \"text.tpr\""
    echo "-----------------------------"
    echo "[option1]"
    echo " -sql: SQL Text TOP Order by"
    echo " -sql-detail: SQL TOP Line Number Count"
    echo " -wait : Wait Event Analyzer"
    echo " -wait-detail: Wait Event Linue Number Count"
    echo ""
    echo "[TPR]"
    echo " \"text.tpr\" \#TPR File "
    echo " \"text07*\" \#TPR File List "
    echo "-----------------------------"
}
