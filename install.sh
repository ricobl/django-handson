#!/bin/bash

NOME_VIRTUALENV="env"


mensagem_inicial () {
    echo ""
    echo "    Instalação completa."
    echo ""
    echo "    Execute os seguintes comandos para iniciar:"
    echo ""
    echo "        . $NOME_VIRTUALENV/bin/activate"
    echo "        python manage.py runserver 0.0.0.0:8000"
    echo ""
    echo "    E abra a seguinte URL no browser:"
    echo ""
    echo "        http://0.0.0.0:8000"
    echo ""
}

inicia () {
    ativa

    cria_banco

    mensagem_inicial
}

download() {
    if [ $(which wget) ]; then
        wget $*
    elif [ $(which curl) ]; then
        curl -O $*
    else
        echo 'Wget ou curl não encontrados.' && exit
    fi
}

instala_pip(){
    download http://peak.telecommunity.com/dist/ez_setup.py
    sudo python ez_setup.py
    rm ez_setup.py

    sudo easy_install pip
}

instala_virtualenv () {
    [ -z $(which pip) ] && instala_pip
    sudo pip install virtualenv
}

ativa(){
    [ -d "$NOME_VIRTUALENV" ] || cria_virtualenv
	. "$NOME_VIRTUALENV/bin/activate"

	python -c 'import django' 2>/dev/null || pip install django==1.3
	# python -c 'import django' 2>/dev/null || echo 'instalar django'
	python -c 'import sqlite3' 2>/dev/null || pip install pysqlite
}

cria_virtualenv() {
	python -c 'import virtualenv' 2> /dev/null || instala_virtualenv

	virtualenv "$NOME_VIRTUALENV" --no-site-packages
}

cria_banco(){
    python manage.py syncdb --noinput
}

limpa () {
    rm -rf build/ env/
}


[ -n "$1" ] && $* || inicia

