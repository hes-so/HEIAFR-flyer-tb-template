# SPDX-FileCopyrightText: 2026 Jacques Supcik <jacques.supci@hes-so.ch>
#
# SPDX-License-Identifier: MIT

thumbnail:
    typst compile template/main.typ --root . --pages 1 --ppi 300 thumbnail.png

reformat:
    typstyle . --inplace --line-width 100

check:
    pre-commit run -a
    typstyle . --check --line-width 100

install_local:
    utpm pkg install .
