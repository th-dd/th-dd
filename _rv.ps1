$env:GIT_TERMINAL_PROMPT = "0"
$nl = [char]10
$out = (("protocol=https" + $nl + "host=ghp.th-dd.top" + $nl) | git credential fill 2>&1) -join $nl
$token = [regex]::Match($out, 'password=(\S+)').Groups[1].Value
$h = @("-H", "Authorization: Bearer $token", "-H", "Accept: application/vnd.github+json", "-H", "User-Agent: dsh")
$base = "https://ghp.th-dd.top/https://api.github.com/repos/th-dd/th-dd"

$rv = (curl.exe -s -m 25 @h "$base/pulls/73/reviews/5817446707") | ConvertFrom-Json
"=== review by " + $rv.user.login + " (" + $rv.state + ") ==="
$rv.body

"=== inline comments ==="
$cs = (curl.exe -s -m 25 @h "$base/pulls/73/comments?per_page=100") | ConvertFrom-Json
"count: " + $cs.Count
foreach ($c in $cs) {
  "---- " + $c.path + " :" + $c.line + " (" + $c.user.login + ") ----"
  $c.body
}
