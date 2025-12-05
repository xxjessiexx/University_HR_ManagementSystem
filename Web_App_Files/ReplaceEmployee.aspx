<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReplaceEmployee.aspx.cs" Inherits="UNI.ReplaceEmployee" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Replace Employee</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #eee;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .input {
            margin-bottom: 12px;
            padding: 10px;
            width: 100%;
            border: 1px solid #ffb6d5;
            border-radius: 6px;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            border: 1px solid #bbb;
            background: #fafafa;
            margin-top: 10px;
        }

        .btn:hover {
            background: #f0e9ff;
            border-color: #c6b8f7;
        }

        .success {
            color: green;
            font-weight: bold;
        }

        .error {
            color: #c0392b;
            font-weight: bold;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <!-- 🌸 ADMIN NAVBAR (MATCHED) -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>UniBlossom HR (Admin)
            </div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <!-- no logout button here -->
            </div>

        </div>
    </header>

    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Replace Another Employee</div>

        <!-- INPUT CARD -->
        <div class="form-card">

            <label>Employee to Replace (Emp1_ID):</label>
            <asp:TextBox ID="txtEmp1" runat="server" CssClass="input"></asp:TextBox>

            <label>Employee Replacement (Emp2_ID):</label>
            <asp:TextBox ID="txtEmp2" runat="server" CssClass="input"></asp:TextBox>

            <label>From Date:</label>
            <asp:TextBox ID="txtFrom" runat="server" CssClass="input" placeholder="YYYY-MM-DD"></asp:TextBox>

            <label>To Date:</label>
            <asp:TextBox ID="txtTo" runat="server" CssClass="input" placeholder="YYYY-MM-DD"></asp:TextBox>

            <asp:Button 
                ID="btnReplace" 
                runat="server" 
                Text="Replace Employee" 
                CssClass="btn"
                OnClick="btnReplace_Click" />

            <asp:Label 
                ID="lblMessage" 
                runat="server"
                Visible="false">
            </asp:Label>

        </div>

        

    </div>

</form>

</body>
</html>
