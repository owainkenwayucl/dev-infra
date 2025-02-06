c = get_config()  #noqa
c.JupyterHub.port = 8000
c.JupyterHub.ssl_cert = '/home/jhrole/jh.crt'
c.JupyterHub.ssl_key = '/home/jhrole/jh.key'
c.Authenticator.allow_all = False
c.PAMAuthenticator.admin_groups = {"courseadmin"}
c.PAMAuthenticator.allowed_groups = {"course"}
