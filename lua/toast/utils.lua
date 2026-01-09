local utils = {}

function utils.strip_markdown_blocks(text)
  text = text:gsub("^```[%w]*\n", "")
  text = text:gsub("\n```%s*$", "")
  text = text:gsub("^```[%w]*\r?\n", "")
  text = text:gsub("\r?\n```%s*$", "")
  return text
end

return utils
