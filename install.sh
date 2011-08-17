#!/bin/bash

NOME_VIRTUALENV="env"

instala() {
    [ -z $(which pip) ] && instala_pip

	python -c 'import virtualenv' 2>/dev/null || sudo pip install virtualenv
    cria_virtualenv
    cria_banco
}

download() {
    if [ -n $(which wget) ]; then
        wget $*
    elif [ -n $(which curl) ]; then
        curl -O $*
    else
        echo 'Wget ou curl não encontrados.' && exit
    fi
}

instala_pip(){
    download http://peak.telecommunity.com/dist/ez_setup.py
    python ez_setup.py
    rm ez_setup.py

    easy_install pip
}

ativa(){
	. "$NOME_VIRTUALENV/bin/activate"
}

cria_virtualenv() {
    [ -z $(which pip) ] && instala_pip

	virtualenv "$NOME_VIRTUALENV" --no-site-packages

	ativa

	python -c 'import django' 2>/dev/null || pip install django==1.3
	python -c 'import sqlite3' 2>/dev/null || pip install pysqlite
}

cria_banco(){
    ativa
    python manage.py syncdb --noinput
}

limpa () {
    rm -rf build/ env/
}

[ -n "$1" ] && $1 || instala

