<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="HR.LogIn" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Login</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>

    <form id="form1" runat="server">

        <div class="container-page" style="max-width:430px; margin-top:80px;">
            
            <div class="page-title" style="text-align:center;">
                Employee Login
            </div>

            <div class="card">

                <label>User Name</label>
                <asp:TextBox ID="UserName" runat="server"></asp:TextBox>

                <label>Password</label>
                <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>

                <asp:Button 
                    ID="Button1" 
                    runat="server" 
                    Text="Log In" 
                    CssClass="btn"
                    OnClick="Login" />

                <asp:Label 
                    ID="errorLabel" 
                    runat="server" 
                    CssClass="error" 
                    Visible="false">
                </asp:Label>

            </div>

        </div>

    </form>

</body>
</html>
