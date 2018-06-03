#!/bin/bash


export FLASK_APP=flaskr
export FLASK_ENV=development
where=$(pipenv --venv)
# -z 代表空, -n 为非空
if [ -n "$where" ]; then
    "${where}/bin/flask" run
fi