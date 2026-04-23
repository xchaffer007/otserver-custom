## Sobre o projeto

Este projeto é baseado em um servidor open source de OTServer/TFS, utilizado como base de estudo e customização.
Meu foco neste repositório é demonstrar modificações no core, scripts Lua e integração client-server.

## Modificações implementadas

- Alterações em `src/monster.cpp` e `src/monster.h` para lógica de foco em summons
- Alterações em `src/map.h` e `src/const.h` para aumentar a área de tiles enviada ao client
- Scripts Lua para testes de summon, movimentação e efeitos
- Base para sistema de summon com owner, progressão e persistência em banco de dados
