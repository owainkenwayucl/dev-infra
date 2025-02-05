c = get_config()  #noqa
c.JupyterHub.port = 443
c.JupyterHub.ssl_cert = '/root/jh.crt'
c.JupyterHub.ssl_key = '/root/jh.key'
c.Authenticator.allow_all = False
c.PAMAuthenticator.admin_groups = {"courseadmin"}
c.PAMAuthenticator.allowed_groups = {"course"}