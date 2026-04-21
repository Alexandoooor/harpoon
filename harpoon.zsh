BOOKMARK_FILE="$XDG_CONFIG_HOME/.dirhooks"

alias j=jump

hook() {
  local name=$1

  if [[ -z "${name}" ]]; then
    echo "Usage: hook <name>"
    return 1
  fi

  grep -v "^${name}:" "${BOOKMARK_FILE}" 2>/dev/null > "${BOOKMARK_FILE}.tmp"
  echo "${name}:${PWD}" >> "${BOOKMARK_FILE}.tmp"
  \mv "${BOOKMARK_FILE}.tmp" "${BOOKMARK_FILE}"

  echo "Hooked '${name}' to ${PWD}"
}

jump() {
  local name=$1
  local match
  local dir

  match=$(grep "^${name}:" "${BOOKMARK_FILE}")
  dir=${match#*:}

  if [[ -z "${dir}" ]]; then
    echo "No hook found for '${name}'"
    return 1
  fi

  cd "${dir}" || echo "Failed to cd into ${dir}"
}

unhook() {
  local name=$1
  local match
  local dir

  if [[ -z "${name}" ]]; then
    echo "Usage: unhook <name>"
    return 1
  fi

  match=$(grep "^${name}:" "${BOOKMARK_FILE}")
  dir=${match#*:}

  if [[ -z "${dir}" ]]; then
    echo "No hook found for '${name}'"
    return 1
  fi

  grep -v "^${name}:" "${BOOKMARK_FILE}" > "${BOOKMARK_FILE}.tmp"
  \mv "${BOOKMARK_FILE}.tmp" "${BOOKMARK_FILE}"

  echo "Removed hook '${name}'"
}

hooks() {
  if [[ -f "${BOOKMARK_FILE}" ]]; then
    cat "${BOOKMARK_FILE}"
  else
    echo "No hooks yet."
  fi
}

harpoon() {
    if [[ "$1" == "init" ]]; then
        if [[ ! -f "${BOOKMARK_FILE}" ]]; then
            touch "${BOOKMARK_FILE}"
            echo "Initialized ${BOOKMARK_FILE}"
        fi
    else
        cat <<'EOF'
Harpoon usage:

Commands:
    hook <name>         add a hook <name> for the current directory
    jump <name>         cd to the directory referenced by <name>
    unhook <name>       remove hook <name>
    hooks               list current hooks
    harpoon             print this message
    harpoon init        create hook file

Example usage:
    cd ~/projects/myapp
    hook app

    cd ~
    jump app  # instantly back to ~/projects/myapp

    hooks     # list all hooks

    unhook app # remove the hook
EOF
        return 1
    fi
}

_harpoon_bookmarks() {
  local -a bookmarks
  if [[ -f "${BOOKMARK_FILE}" ]]; then
    bookmarks=("${(@f)$(< "${BOOKMARK_FILE}")}")
    bookmarks=("${bookmarks[@]%%:*}")
    _describe 'bookmarks' bookmarks
  fi
}

compdef _harpoon_bookmarks jump
compdef _harpoon_bookmarks unhook
