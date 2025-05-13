return {
    settings = {

        tailwindCSS = {
            includeLanguages = {
                rust = "html", -- let it parse html-like macros in Rust
                templ = "html",
            },
            experimental = {
                classRegex = {
                    'class: "([^"]*)"',   -- for Yew's `class: "..."` syntax
                    'class\\(([^)]*)\\)', -- optionally support `class(...)`
                },
            },
        },
    }
}
