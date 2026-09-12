# security.txt

The [RFC 9116](https://www.rfc-editor.org/rfc/rfc9116) `security.txt` for
Innovation Harbor B.V. and the brands in the group. Every website we operate
serves the same file at `/.well-known/security.txt`; this repository is where
it is maintained, so you can verify here that what a site serves is genuine.

## Reporting a vulnerability

Mail **security@xyphen-it.nl**. We read this address on business days and aim
to acknowledge within two working days.

We currently do not publish a PGP key. Keep the first message free of
sensitive details (a short description of what you found and on which site is
enough); we then exchange keys or agree on another secure channel before you
send the full report.

What we ask of you:

- Give us reasonable time to fix the issue before disclosing it.
- Do not access, modify or delete data that is not yours, and stop as soon as
  you have shown the issue exists.
- No denial of service, spam, social engineering or physical attacks.

What you can expect from us:

- We will not take legal action against research done in good faith within
  these rules.
- We keep you informed of progress and let you know when the issue is fixed.
- We credit you for the finding if you want us to.

## How it is served

The file is packaged into a small nginx image (`Dockerfile`, `nginx.conf`)
that runs on our Kubernetes cluster. The edge load balancers route the
`/.well-known/security.txt` path of every hostname to that service, so the
file is identical everywhere, independent of where a site itself is hosted.

`check.sh` validates the file (required fields, `Expires` in the future and
less than a year out). It runs in CI on every change and weekly; a failed
check opens an issue in this repository.

To try it locally:

    docker build -t security-txt .
    docker run --rm -p 8080:8080 security-txt
    curl -i http://localhost:8080/.well-known/security.txt
