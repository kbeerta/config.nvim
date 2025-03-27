return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    single_file_support = true,
    root_dir = function(fname)
        return vim.fs.dirname(vim.fs.find({'Cargo.toml'}, { upward = true })[1])
    end,
}
