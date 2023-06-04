# A robust Dotfiles - Make development environment setup into a science

Quality Assurance by myself: **70%**

## Step by Step for a Fresh Ubuntu 23.04+

### 0. Disable Wireless Powersaving and Files Open Limit

```bash
sudo vi /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

```conf
[connection]
wifi.powersave = 2
```

```bash
sudo systemctl restart NetworkManager
```

```bash
sudo vi /etc/systemd/system.conf
```

```conf
DefaultLimitNOFILE=4096:2097152
```

```bash
sudo vi /etc/systemd/user.conf
```

```conf
DefaultLimitNOFILE=4096:2097152
```

```bash
sudo systemctl daemon-reexec
```

`reboot`

### 1. Install all necessary `APT` packages

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install apt-transport-https glibc-source gcc xclip git curl zsh htop neofetch vim mpv libutf8proc2 libutf8proc-dev libfuse2 cpu-checker screenkey -y
```
### 2. Install `Oh-my-zsh` and `Chrome`, then `reboot`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```bash
cd ~Downloads && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb && cd ~
```

### 3. After `reboot`, install `Linuxbrew`

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 4. Install `zsh-autosuggestions`

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### 5. Install the proper `.zshrc` by clone this repo to `~/temp`, copy all its content to `~`

```bash
git clone https://github.com/lavantien/dotfiles.git ~/temp && mv -v {~/temp/*,~/temp/.*} ~/ && cd ~/temp/.config && mv -v * ~/.config/ && cd ~ && cd ~/temp/.local/share/applications && mv * ~/.local/share/applications && cd ~ && source ~/.zshrc
```
### 6. Install `rust` and its toolchains, then `reboot`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 7. Install `gcc`, `gh`, `neovim`, and other necessary `Brew` packages

```bash
brew install gcc gh go lazygit fzf fd ripgrep bat neovim hyperfine openjdk ruby lua maven node gopls rust-analyzer jdtls lua-language-server yaml-language-server bash-language-server terraform terraform-ls prettier delve vscode-langservers-extracted loc llvm dotenv-linter checkmake luarocks php composer
```

```bash
sudo snap install julia --classic
```

Currently, `julia` build is failed on `brew`, use `snap` instead

### 8. Install `Joplin (snap)`, sync your notes, and setup your `Git` environment:

For a smooth `Git` experience, you should make a `.netrc` file in your home directory and add auth token:  
`machine github.com login lavantien password ghp_klsdfjalsdkfjdsjfalsdkldasfjkasldfjalsdfjalsdjfk`  
For `gh`, run `gh auth login` and follow instruction to setup `GitHub CLI` 

### 9. Run `./git-clone-all your-github-username` on `~/dev/personal` for cloning all of your repos

```bash
mkdir -p ~/dev/personal && cp ~/git-clone-all.sh ~/dev/personal/ && cd ~/dev/personal && ./git-clone-all.sh your-github-username && cd ~
```

### 10. Install `Iosevka Nerd Font` (replace version `v3.0.1` with whatever latest)

```bash
cd ~/Downloads && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/Iosevka.zip && mkdir Iosevka && unzip Iosevka.zip -d Iosevka && cd Iosevka && sudo mkdir -p /usr/share/fonts/truetype/iosevka-nerd-font && sudo cp *.ttf /usr/share/fonts/truetype/iosevka-nerd-font/ && cd .. && rm -r Iosevka Iosevka.zip && cd ~ && sudo fc-cache -f -v
```

### 11. Install `wezterm`

```bash
brew tap wez/wezterm-linuxbrew
```

```bash
brew install wezterm
```

### 12. Install `GRPC`, `GRPC-Web`, and `protoc-gen`

```bash
brew install grpc protoc-gen-grpc-web
```

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
```

```bash
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

### 13. Install `VSCode` and `CodeLLDB` (replace version `v1.9.2` with whatever latest)

```bash
cd ~/Downloads && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && rm -f packages.microsoft.gpg && cd ~ && sudo apt update && sudo apt install code -y
```

```bash
cd ~/Downloads && wget https://github.com/vadimcn/codelldb/releases/download/v1.9.2/codelldb-x86_64-linux.vsix && code --install-extension codelldb-x86_64-linux.vsix && rm codelldb-x86_64-linux.vsix && cd ~
```

### 14. Install `DotNet SDK`

```bash
cd ~/Downloads && declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi) && wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && cd ~ && sudo apt update && sudo apt install dotnet-sdk-7.0 -y
```

```bash
sudo cp -r /usr/share/dotnet/* /usr/lib/dotnet/ && dotnet --info
```

### 15. Install `Qemu KVM`

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo && kvm-ok
```

```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
```

### 16. Install `Android Studio`, `Android SDK`, and `Flutter`

```bash
sudo snap install android-studio --classic
```

Run `Android Studio` and install default configuration, then click `More tools` -> `Manages SDKs` -> `` -> tick `Android SDK CLI`

```bash
sudo snap install flutter --classic
```

```bash
flutter doctor
```

### 17. Install `Kreya` and `DBbGate`

```bash
sudo snap install kreya
```

```bash
sudo snap install dbgate
```

### 18. Install `Docker Compose`, `FlatHub`, and `Vulkan`, then `reboot`

### 19. Install `kubectl`, and `minikube`

### 20. Install `Wine`, `Lutris`, and `MangoHUD`

### 21. Install `OBS`, `Gimp`, `Inkscape`, `LibreOffice`, `Blender`

### 22. Install `Steam`, `Battlenet`, and `Diablo 2 Resurrected`

## Healthcheck

### Flutter Doctor

```bash
flutter doctor
```

<details>
  <summary>expand result</summary>

```bash
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.10.3, on Ubuntu 23.04 6.2.0-20-generic, locale en_US.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
[✓] Chrome - develop for the web
[✓] Linux toolchain - develop for Linux desktop
[✓] Android Studio (version 2022.2)
[✓] VS Code (version 1.78.2)
[✓] Connected device (2 available)
[✓] Network resources

• No issues found!
```

</details>

### MiniKube

```bash
minikube start
```

<details>
  <summary>expand result</summary>

```bash

```

</details>

```bash
minikube stop
```

### Neovim Deps (fresh 100% OK)

```bash
npm i -g neovim
```

```bash
cpan App::cpanminus
```

```bash
cpanm -n Neovim::Ext
```

```bash
pip3 install neovim
```

```bash
sudo apt install ubuntu-dev-tools
```

```bash
gem install neovim
```

```bash
nvim +che
```

### Neovim Deps (after setup 100% OK)

<details>
  <summary>`n +che` result</summary>
  
```checkhealth
==============================================================================
lazy: require("lazy.health").check()

lazy.nvim ~

- OK Git installed
- OK no existing packages found by other package managers
- OK packer_compiled.lua not found

==============================================================================
mason: require("mason.health").check()

mason.nvim ~

- OK mason.nvim version v1.1.1
- OK PATH: prepend
- OK Providers:
  mason.providers.registry-api
  mason.providers.client
- OK neovim version >= 0.7.0

mason.nvim [Registries] ~

- OK Registry `github.com/mason-org/mason-registry version: 2023-06-03-jumpy-hate` is installed.
- OK Registry `github.com/mason-org/mason-registry version: 2023-06-03-jumpy-hate` is installed.

mason.nvim [Core utils] ~

- OK unzip: `UnZip 6.00 of 20 April 2009, by Debian. Original by Info-ZIP.`
- OK wget: `GNU Wget 1.21.3 built on linux-gnu.`
- OK curl: `curl 8.1.2 (x86_64-pc-linux-gnu) libcurl/8.1.2 OpenSSL/1.1.1u zlib/1.2.13 brotli/1.0.9 zstd/1.5.5 libidn2/2.3.4 libssh2/1.11.0 nghttp2/1.53.0 librtmp/2.3`
- OK gzip: `gzip 1.12`
- OK tar: `tar (GNU tar) 1.34`
- OK bash: `GNU bash, version 5.2.15(1)-release (x86_64-pc-linux-gnu)`
- OK sh: `Ok`

mason.nvim [Languages] ~

- OK Go: `go version go1.20.4 linux/amd64`
- OK Ruby: `ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-linux]`
- OK PHP: `PHP 8.2.6 (cli) (built: May  9 2023 06:25:31) (NTS)`
- OK cargo: `cargo 1.70.0 (ec8a8a0ca 2023-04-25)`
- OK node: `v20.2.0`
- OK luarocks: `/home/linuxbrew/.linuxbrew/bin/luarocks 3.9.2`
- OK Composer: `Composer version 2.5.7 2023-05-24 15:00:39`
- OK java: `openjdk version "20.0.1" 2023-04-18`
- OK julia: `julia version 1.9.0`
- OK python3: `Python 3.11.3`
- OK RubyGem: `3.4.13`
- OK javac: `javac 20.0.1`
- OK npm: `9.6.7`
- OK pip3: `pip 23.1.2 from /home/linuxbrew/.linuxbrew/Cellar/python@3.11/3.11.3/lib/python3.11/site-packages/pip (python 3.11)`

mason.nvim [GitHub] ~

- OK GitHub API rate limit. Used: 5. Remaining: 4995. Limit: 5000. Reset: Sun 04 Jun 2023 04:01:39 AM +07.

==============================================================================
null-ls: require("null-ls.health").check()

- OK dart_format: the command "dart" is executable.
- OK prettier: the command "prettier" is executable.
- OK checkmake: the command "checkmake" is executable.
- OK clang_check: the command "clang-check" is executable.
- refactoring: cannot verify if the command is an executable.
- OK gitsigns: the source "gitsigns" can be ran.

==============================================================================
nvim: require("nvim.health").check()

Configuration ~

- OK no issues found

Runtime ~

- OK $VIMRUNTIME: /home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.1/share/nvim/runtime

Performance ~

- OK Build type: Release

Remote Plugins ~

- OK Up to date

terminal ~

- key_backspace (kbs) terminfo entry: `key_backspace=^H`
- key_dc (kdch1) terminfo entry: `key_dc=\E[3~`
- $TERM_PROGRAM="WezTerm"
- $COLORTERM="truecolor"

==============================================================================
nvim-treesitter: require("nvim-treesitter.health").check()

Installation ~

- OK `tree-sitter` found 0.20.8 (parser generator, only needed for :TSInstallFromGrammar)
- OK `node` found v20.2.0 (only needed for :TSInstallFromGrammar)
- OK `git` executable found.
- OK `cc` executable found. Selected from { vim.NIL, "cc", "gcc", "clang", "cl", "zig" }
  Version: cc (Ubuntu 12.2.0-17ubuntu1) 12.2.0
- OK Neovim was compiled with tree-sitter runtime ABI version 14 (required >=13). Parsers must be compatible with runtime ABI.

OS Info:
{
machine = "x86_64",
release = "6.2.0-20-generic",
sysname = "Linux",
version = "#20-Ubuntu SMP PREEMPT_DYNAMIC Thu Apr 6 07:48:48 UTC 2023"
} ~

Parser/Features H L F I J

- bash ✓ ✓ ✓ . ✓
- c ✓ ✓ ✓ ✓ ✓
- css ✓ . ✓ ✓ ✓
- dockerfile ✓ . . . ✓
- go ✓ ✓ ✓ ✓ ✓
- gomod ✓ . . . ✓
- gosum ✓ . . . .
- gowork ✓ . . . ✓
- graphql ✓ . . ✓ ✓
- html ✓ ✓ ✓ ✓ ✓
- http ✓ . . . ✓
- java ✓ ✓ ✓ ✓ ✓
- javascript ✓ ✓ ✓ ✓ ✓
- jsdoc ✓ . . . .
- json ✓ ✓ ✓ ✓ .
- lua ✓ ✓ ✓ ✓ ✓
- make ✓ . ✓ . ✓
- markdown ✓ . ✓ ✓ ✓
- nix ✓ ✓ ✓ . ✓
- proto ✓ . ✓ . .
- python ✓ ✓ ✓ ✓ ✓
- query ✓ ✓ ✓ ✓ ✓
- rust ✓ ✓ ✓ ✓ ✓
- scss ✓ . ✓ ✓ .
- toml ✓ ✓ ✓ ✓ ✓
- typescript ✓ ✓ ✓ ✓ ✓
- vim ✓ ✓ ✓ . ✓
- vimdoc ✓ . . . ✓
- yaml ✓ ✓ ✓ ✓ ✓

Legend: H[ighlight], L[ocals], F[olds], I[ndents], In[j]ections
+) multiple parsers found, only one will be used
x) errors found in the query, try to run :TSUpdate {lang} ~

==============================================================================
provider: health#provider#check

Clipboard (optional) ~

- OK Clipboard tool found: xclip

Python 3 provider (optional) ~

- `g:python3_host_prog` is not set. Searching for python3 in the environment.
- Multiple python3 executables found. Set `g:python3_host_prog` to avoid surprises.
- Executable: /home/linuxbrew/.linuxbrew/bin/python3
- Other python executable: /usr/bin/python3
- Other python executable: /bin/python3
- Python version: 3.11.3
- pynvim version: 0.4.3
- OK Latest pynvim is installed.

Python virtualenv ~

- OK no $VIRTUAL_ENV

Ruby provider (optional) ~

- Ruby: ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-linux]
- Host: /home/linuxbrew/.linuxbrew/lib/ruby/gems/3.2.0/bin/neovim-ruby-host
- OK Latest "neovim" gem is installed: 0.9.0

Node.js provider (optional) ~

- Node.js: v20.2.0
- Nvim node.js host: /home/linuxbrew/.linuxbrew/lib/node_modules/neovim/bin/cli.js
- OK Latest "neovim" npm/yarn/pnpm package is installed: 4.10.1

Perl provider (optional) ~

- Disabled (g:loaded_perl_provider=0).

==============================================================================
telescope: require("telescope.health").check()

Checking for required plugins ~

- OK plenary installed.
- OK nvim-treesitter installed.

Checking external dependencies ~

- OK rg: found ripgrep 13.0.0
- OK fd: found fd 8.7.0

===== Installed extensions ===== ~

==============================================================================
vim.lsp: require("vim.lsp.health").check()

- LSP log level : WARN
- Log path: /home/lavantien/.local/state/nvim/lsp.log
- Log size: 0 KB

vim.lsp: Active Clients ~

- No active clients

==============================================================================
vim.treesitter: require("vim.treesitter.health").check()

- Nvim runtime ABI version: 14
- OK Parser: bash ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/bash.so
- OK Parser: c ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/c.so
- OK Parser: css ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/css.so
- OK Parser: dockerfile ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/dockerfile.so
- OK Parser: go ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/go.so
- OK Parser: gomod ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/gomod.so
- OK Parser: gosum ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/gosum.so
- OK Parser: gowork ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/gowork.so
- OK Parser: graphql ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/graphql.so
- OK Parser: html ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/html.so
- OK Parser: http ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/http.so
- OK Parser: java ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/java.so
- OK Parser: javascript ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/javascript.so
- OK Parser: jsdoc ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/jsdoc.so
- OK Parser: json ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/json.so
- OK Parser: lua ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/lua.so
- OK Parser: make ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/make.so
- OK Parser: markdown ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/markdown.so
- OK Parser: nix ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/nix.so
- OK Parser: proto ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/proto.so
- OK Parser: python ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/python.so
- OK Parser: query ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/query.so
- OK Parser: rust ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/rust.so
- OK Parser: scss ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/scss.so
- OK Parser: toml ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/toml.so
- OK Parser: typescript ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/typescript.so
- OK Parser: vim ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/vim.so
- OK Parser: vimdoc ABI: 14, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/vimdoc.so
- OK Parser: yaml ABI: 13, path: /home/lavantien/.local/share/nvim/lazy/nvim-treesitter/parser/yaml.so
- OK Parser: c ABI: 14, path: /home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.1/lib/nvim/parser/c.so
- OK Parser: lua ABI: 14, path: /home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.1/lib/nvim/parser/lua.so
- OK Parser: query ABI: 14, path: /home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.1/lib/nvim/parser/query.so
- OK Parser: vim ABI: 14, path: /home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.1/lib/nvim/parser/vim.so
- OK Parser: vimdoc ABI: 14, path: /home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.1/lib/nvim/parser/vimdoc.so

````

</details>

## Neovim Setup From Scratch

### Usage

- Install `linuxbrew` and then `$ brew install neovim`
- Make sure to run `$ nvim +che` to ensure all dependencies are installed

### Key Bindings

- In Neovim Normal Mode, hit `:nmap` to see the list of all bindings
- To see bindings of a certain key, hit `:nmap <leader>`
- Or you can just use Telescope to do the deed `<leader>vk`, in this case, holding the space bar and pressing `vk`

### References

<details>
  <summary>expand</summary>

- 0 to LSP: <https://youtu.be/w7i4amO_zaE>
- Zero to IDE: <https://youtu.be/N93cTbtLCIM>
- Effective Neovim: Instant IDE: <https://youtu.be/stqUbv-5u2s>
- Kickstart.nvim: <https://github.com/nvim-lua/kickstart.nvim>
- Neovim Null-LS - Hooks For LSP | Format Code On Save:
  <https://youtu.be/ryxRpKpM9B4>
- Null-LS built-in:
  <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md>
- Debugging in Neovim: <https://youtu.be/0moS8UHupGc>
- How to Debug like a Pro: <https://miguelcrespo.co/how-to-debug-like-a-pro-using-neovim>
- Nvim DAP getting started: <https://davelage.com/posts/nvim-dap-getting-started/>

</details>

## Fix Google Cloud CLI (broken installation & missing python2 dep)

```bash
echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/cloud.google.gpg > /dev/null
sudo apt update && sudo apt install kubectl google-cloud-cli
gcloud init

wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar xzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --enable-optimizations
sudo make altinstall
python2.7 -V
sudo ln -sfn '/usr/local/bin/python2.7' '/usr/bin/python2'
python2 -V
sudo rm /usr/local/lib/pkgconfig/python-2.7.pc /usr/local/lib/libpython2.7.a
sudo rm -rf /usr/local/include/python2.7

sudo apt install google-cloud-cli-app-engine-go google-cloud-cli-app-engine-grpc google-cloud-cli-cloud-build-local google-cloud-cli-firestore-emulator google-cloud-cli-minikube google-cloud-cli-tests
# still failed due to python2.7
````
