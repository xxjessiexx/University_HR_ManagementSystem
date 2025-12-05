<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeesPerDept.aspx.cs" Inherits="UNI.EmployeesPerDept" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employees Per Department</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        .card {
            background: #fff;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #eee;
            margin-bottom: 25px;
        }

        .btn {
            padding: 10px 18px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background: #f8f8f8;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn:hover {
            background: #f0e9ff;
            border-color: #c6b8f7;
        }

        .msg {
            font-weight: 600;
            color: #c0392b;
            margin-bottom: 12px;
            display: block;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- ▬▬▬▬▬▬▬▬▬ MATCHING SAKURA ADMIN NAVBAR ▬▬▬▬▬▬▬▬▬ -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand"><span class="logo-dot"></span>UniBlossom HR (Admin)</div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <a href="AdminLogin.aspx">Logout</a>
            </div>
        </div>
    </header>

    <!-- ▬▬▬▬▬▬▬▬▬ PAGE CONTENT ▬▬▬▬▬▬▬▬▬ -->
    <div class="container-page">

        <div class="page-title">Employees Per Department</div>

        <div class="card">
            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <asp:GridView ID="gvDept" runat="server" CssClass="table"
                AutoGenerateColumns="true"></asp:GridView>
        </div>

        <div>
            <asp:Button ID="btnBack" runat="server" Text="Back to Admin Home"
                CssClass="btn" OnClick="btnBack_Click" />
        </div>

    </div>

</form>
</body>
</html>

