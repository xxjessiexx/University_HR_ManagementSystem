<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddHoliday.aspx.cs" Inherits="UNI.AddHoliday" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Holiday - Admin</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        /* MATCH EMPLOYEE PAGE CARD + FORM STYLING */

        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            border: 1px solid #eee;
        }

        .form-row {
            margin: 14px 0;
            display: flex;
            align-items: center;
        }

        .form-row label {
            width: 180px;
            font-weight: 600;
            color: #444;
        }

        .form-row input[type="text"],
        .form-row input[type="date"] {
            padding: 8px;
            width: 260px;
            border: 1px solid #ccc;
            border-radius: 5px;
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

        .msg {
            font-weight: 600;
            color: #c0392b;
            margin-bottom: 12px;
            display: block;
        }

        .small {
            font-size: 0.9em;
            color: #666;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- ▬▬▬▬▬▬▬▬▬ MATCHING SAKURA NAVBAR (ADMIN VERSION) ▬▬▬▬▬▬▬▬▬ -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand"><span class="logo-dot"></span>UniBlossom HR (Admin)</div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <a href="AdminLogin.aspx">Back</a>
            </div>
        </div>
    </header>

    <!-- ▬▬▬▬▬▬▬▬▬ CONTENT ▬▬▬▬▬▬▬▬▬ -->
    <div class="container-page">

        <!-- PAGE TITLE -->
        <div class="page-title">Add New Official Holiday</div>

        <!-- MAIN CARD -->
        <div class="form-card">

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <!-- HOLIDAY NAME -->
            <div class="form-row">
                <label for="txtName">Holiday Name:</label>
                <asp:TextBox ID="txtName" runat="server" Width="260px" />
            </div>

            <!-- FROM DATE -->
            <div class="form-row">
                <label for="txtFrom">From Date:</label>
                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" Width="200px" />
            </div>

            <!-- TO DATE -->
            <div class="form-row">
                <label for="txtTo">To Date:</label>
                <asp:TextBox ID="txtTo" runat="server" TextMode="Date" Width="200px" />
            </div>

            <!-- BUTTONS -->
            <div style="margin-top:18px;">
                <asp:Button ID="btnAdd" runat="server" Text="Add Holiday" CssClass="btn" OnClick="btnAdd_Click" />
                &nbsp;
                <asp:Button ID="btnBack" runat="server" Text="Back to Admin Home" CssClass="btn" OnClick="btnBack_Click" />
            </div>

        </div>

       

    </div>

</form>
</body>
</html>
