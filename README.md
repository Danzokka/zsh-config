# zsh-config installer

Este repositório contém um instalador (`install.sh`) que automatiza a configuração do Zsh no Linux.

**O que o script faz**

- Detecta a distribuição (Fedora `dnf`, Arch `pacman`, Debian/Ubuntu `apt`).
- Instala pacotes necessários: `zsh`, `git`, `curl`, `unzip` (usa `sudo` internamente quando necessário).
- Instala o Oh My Zsh de forma não interativa.
- Clona plugins recomendados em `~/.oh-my-zsh/custom/plugins`:
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
  - `zsh-history-substring-search`
- Atualiza/gera `~/.zshrc` com a linha de `plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)`.
- Tenta definir o `zsh` como shell padrão (`chsh`).
- Instala o prompt `starship` (instalador oficial com `--yes`).
- Extrai `zsh-config.zip` para o diretório home caso o arquivo esteja presente no diretório onde o script é executado.

**Requisitos**

- Conexão com a Internet
- `git` disponível (o script instala se necessário)
- Permissão para executar comandos com `sudo` quando for preciso instalar pacotes (o script chamará `sudo` internamente)

**Como executar**

1. Torne o script executável (opcional):

```bash
chmod +x install.sh
```

2. Execute o instalador sem `sudo` (recomendado):

```bash
./install.sh
# ou
bash install.sh
```

Observação: não é necessário executar o `install.sh` diretamente com `sudo`. O script chama `sudo` apenas quando precisa instalar pacotes; portanto, você pode rodá-lo como seu usuário normal e fornecer a senha quando solicitado.

Se preferir evitar prompts de `sudo`, execute assim (não recomendado a menos que entenda os riscos):

```bash
sudo bash install.sh
```

**Soluções rápidas de problemas**

- Se `chsh` falhar para alterar o shell, defina manualmente com:

```bash
chsh -s "$(which zsh)"
```

- Se algum plugin não for clonado, verifique se `git` está instalado e se há conectividade com o GitHub.
- Se `zsh-config.zip` não for encontrado, coloque-o no mesmo diretório do `install.sh` antes de executar.

**Notas finais**

- O script foi escrito para ser seguro e não substituir arquivos do usuário sem aviso (ele mantém o `~/.zshrc` existente e atualiza a linha de `plugins=` quando possível).
- Se quiser revisar o que será executado, abra `install.sh` antes de rodar.

---

Se quiser que eu adicione instruções extras, traduções ou um arquivo de licença, diga qual e eu adiciono.
