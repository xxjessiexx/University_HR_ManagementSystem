<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Employees_Details.aspx.cs" Inherits="UNI.Employees_Details" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Profiles</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        /* CARD STYLING */
        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            border: 1px solid #eee;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .msg {
            font-weight: 600;
            color: #c0392b;
            margin-bottom: 12px;
            display: block;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            border: 1px solid #bbb;
            background: #fafafa;
        }

        .btn:hover {
            background: #f0e9ff;
            border-color: #c6b8f7;
        }

        /* COMPACT GRID */
        .grid-container {
            overflow-x: auto;
            margin-top: 15px;
        }

        .grid-container table {
            border-collapse: collapse;
            font-size: 14px;
        }

        .grid-container th {
            background: #f7f4ff;
            font-weight: 700;
            padding: 8px;
        }

        .grid-container td {
            padding: 6px;
        }

        .logout-btn {
            background: #ffe3e7;
            border: 1px solid #ffb5c1;
        }

        .logout-btn:hover {
            background: #ffd1da;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- ▬▬▬▬▬▬▬▬▬ ADMIN NAVBAR (LOGOUT REMOVED) ▬▬▬▬▬▬▬▬▬ -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand"><span class="logo-dot"></span>UniBlossom HR (Admin)</div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
               

            <!-- 🚫 Removed the logout link from here -->
            <div class="nav-end"></div>
        </div>
    </header>

    <!-- ▬▬▬▬▬▬▬▬▬ CONTENT ▬▬▬▬▬▬▬▬▬ -->
    <div class="container-page">

        <div class="page-title">All Employee Profiles</div>

        <div class="form-card">

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <div class="grid-container">
                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="true"
                    CssClass="table"
                    GridLines="Both"
                    BorderColor="#ccc"
                    BorderStyle="Solid"
                    BorderWidth="1px">
                </asp:GridView>
            </div>

            <br />

            <!-- BOTTOM LOGOUT BUTTON ONLY -->
            <asp:Button ID="btnBack" runat="server" Text="Back to Admin" CssClass="btn logout-btn"
                PostBackUrl="~/AdminLogin.aspx" />

        </div>

    </div>

</form>
</body>
</html>

