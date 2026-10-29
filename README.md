# NAVALHA NEGRA — Projeto Integrador Parte 3
Barbearia · clientes e agendamentos · Aluno: Guilherme Felberque

## Como rodar
1. Ligue o MySQL. Se a senha do seu `root` não for vazia, troque `spring.datasource.password` em `src/main/resources/application.properties`.
2. No mesmo arquivo, coloque **o seu gmail** em `app.admin.email` (e uma senha em `app.admin.senha`). Esse é o único email que vê os cadastros salvos.
3. Rode `DemoApplication`.
   O Spring cria sozinho o banco, as tabelas (`schema.sql`) e a conta do administrador. Se as tabelas já existiam, as colunas novas (`perfil`, `email`) são adicionadas sozinhas.
   Usa o driver mysql-connector-java 5.1.49, compatível com MySQL antigo.
4. Abra **http://localhost:8080**

## Quem pode fazer o quê
| Pessoa | Pode |
|---|---|
| Qualquer visitante | Criar cadastro (tela "Cadastre-se"), que já cria o login dele |
| Cliente logado | Ver a tela de boas-vindas |
| Administrador (o gmail do `application.properties`) | Ver a tela de boas-vindas **e** os cadastros salvos (lista, ficha, excluir) |

A proteção está no Java (`AdminInterceptor`), não só na tela: um cliente que tentar chamar `/api/cadastros` recebe 403.

## Estrutura (arquitetura em camadas)
```
src/main/java/com/example/demo
├── DemoApplication.java
├── model/        Usuario.java, Cadastro.java            (classes de dados)
├── repository/   UsuarioRepository, CadastroRepository  (Spring JDBC / JdbcTemplate)
├── service/      UsuarioService, CadastroService        (regras de negócio)
├── controller/   AuthController, CadastroController, ErroHandler
├── dto/          LoginRequest, CadastroRequest          (dados que chegam das telas)
├── config/       DadosIniciais (admin + colunas novas), AdminInterceptor, WebConfig
└── util/         SenhaUtil (BCrypt)
src/main/resources/static
├── index.html       Tela 1: Login
├── cadastro.html    Cadastro público (6 campos + email e senha)
├── home.html        Boas-vindas com imagem em tela cheia
├── cadastros.html   Cadastros salvos (só admin)
├── css/style.css    Identidade visual (preto/amarelo, flat, alto contraste)
├── js/sessao.js
└── img/hero.svg     Imagem fullscreen
```

## Endpoints
| Método | Rota | Quem | O que faz |
|---|---|---|---|
| POST | `/api/login` | todos | Login (JSON `{email, senha}`) |
| GET | `/api/usuario` | logado | Quem está logado e se é admin |
| POST | `/api/logout` | logado | Sai |
| POST | `/api/cadastros` | todos | Cria cadastro + login → "Cadastro realizado com sucesso!" |
| GET | `/api/cadastros` | admin | Lista todos |
| GET | `/api/cadastros/{id}` | admin | Busca um |
| DELETE | `/api/cadastros/{id}` | admin | Exclui (soft delete) e remove o login do cliente |

## Roteiro para apresentar ao professor
1. **Senha incorreta**: na tela de login, digite uma senha errada e mostre a caixa vermelha "Email ou senha inválidos".
2. **Inserção**: clique em "Cadastre-se" e cadastre 3 clientes completos, cada um com um email diferente.
3. **Feedback**: depois de cada um aparece "Cadastro realizado com sucesso!".
4. **Transição de sessão**: entre com o login de um cliente; abre a tela com a imagem em tela cheia, sem acesso aos cadastros.
5. **Recuperação individual**: saia e entre com o gmail de administrador → "Ver cadastros salvos" → "Ver" em cada cliente.
6. **Auditoria do banco**: no Workbench rode `SELECT email, perfil, senha_hash FROM usuarios;` e mostre que as senhas estão como `$2a$10$...`.

## Desafios extras feitos
- ⭐ 1: máscaras de CEP `00000-000` e telefone `(00) 90000-0000`
- ⭐ 2: ViaCEP preenche o endereço ao digitar o CEP (precisa de internet)
- ⭐ 3: campo `data_criacao` automático + botão Excluir (soft delete, campo `ativo`)
