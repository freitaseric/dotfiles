# Sem mensagem de boas-vindas
set -g fish_greeting

# Editor padrão
set -gx EDITOR nvim
set -gx VISUAL nvim

# Node.js por projeto. O fnm é o único gerenciador de versões usado aqui.
if type -q fnm
    fnm env --use-on-cd --shell fish | source
end

# Ferramentas modernas
if type -q eza
    abbr -a ls 'eza'
    abbr -a ll 'eza -lah --group-directories-first'
    abbr -a la 'eza -a'
    abbr -a lt 'eza --tree --level=2'
end

if type -q bat
    abbr -a cat 'bat --plain'
end

# Navegação inteligente
if type -q zoxide
    zoxide init fish | source
end

# Prompt
if type -q starship
    starship init fish | source
end
