<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="UNI.AdminLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login</title>
    <style>
        .login-panel { width:420px; margin:60px auto; border:1px solid #ddd; padding:26px; border-radius:6px; }
        .form-row { margin:10px 0; }
        label { display:inline-block; width:120px; font-weight:600; }
        .msg { margin-top:12px; }
        .small { font-size:0.9em; color:#666; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-panel">
            <h2>Admin Login</h2>
            <hr />

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" ForeColor="Red"></asp:Label>

            <div class="form-row">
                <label for="txtAdminID">Admin ID</label>
                <asp:TextBox ID="txtAdminID" runat="server" Width="200px" />
            </div>

            <div class="form-row">
                <label for="txtAdminPass">Password</label>
                <asp:TextBox ID="txtAdminPass" runat="server" TextMode="Password" Width="200px" />
            </div>

            <div class="form-row">
                <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
                &nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false" />
            </div>

        </div>
    </form>
</body>
</html>
