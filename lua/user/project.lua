local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
    return
end
project.setup {
    detection_methods = { "pattern" },

    -- patterns used to detect root dir, when **"pattern"** is in detection_methods
    patterns = {
        ".git",
        "Makefile",
        "package.json",
        "go.mod",
        "requirements.txt",
        "Cargo.toml",
        "Cargo.toml",
        "venv/",
        "rootfile",
    },
}

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
    return
end

telescope.load_extension "projects"
