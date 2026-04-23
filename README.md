# OTServer Custom

Projeto pessoal baseado em um OTServer open source, com foco em customização de sistemas, modificação de core em C++ e integração client-server.

## Minhas modificações

### Core (C++)
- Alterações em `src/monster.cpp` e `src/monster.h`
- Ajuste na lógica de foco dos monstros para priorizar summons

- Alterações em `src/map.h` e `src/const.h`
- Expansão da quantidade de tiles enviados ao client (fullscreen gameplay)

### Scripts (Lua)
- Desenvolvimento de scripts para sistema de summon
- Testes de movimentação e efeitos
- Integração com eventos de login

### Client (OTClient)
As modificações do client estão em `client_mods/`

- Ajuste na renderização de tiles
- Alterações no volume de dados recebidos
- Preparação para controle de summon via input

## Em desenvolvimento

Atualmente desenvolvendo um sistema avançado de summons:

- Relação entre jogador (owner) e summon
- Sistema de progressão
- Movimentação controlada pelo jogador
- Persistência em banco de dados
- Integração completa client-server

## Tecnologias

- C++
- Lua
- Git
- Uso de IA como apoio para debugging e aprendizado

## Objetivo

Projeto focado em prática real de desenvolvimento, modificação de sistemas existentes e construção de mecânicas de gameplay.
