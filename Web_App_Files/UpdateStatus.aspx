<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UpdateStatus.aspx.cs" Inherits="UNI.UpdateStatus" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Update Employee Status</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border: 1px solid #eee;
            width: 100%;
            max-width: 700px;
            margin: 20px auto;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 22px;
            text-align: center;
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

        .form-row input[type="text"] {
            padding: 8px;
            width: 200px;
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
            color: #c0392b;
            font-weight: 600;
            margin-bottom: 12px;
            display: block;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <!-- ▬▬▬▬▬▬▬▬ ADMIN NAVBAR ▬▬▬▬▬▬▬▬ -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>UniBlossom HR (Admin)
            </div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <a href="AdminLogin.aspx">Logout</a>
            </div>

        </div>
    </header>


    <!-- ▬▬▬▬▬▬▬▬ PAGE CONTENT ▬▬▬▬▬▬▬▬ -->
    <div class="container-page">

        <div class="page-title">Daily Employee Status Update</div>

        <div class="form-card">

            <!-- Message Label -->
            <asp:Label ID="lblMessage" runat="server" CssClass="msg" />

            <!-- Input Row -->
            <div class="form-row">
                <label for="txtEmpID">Employee ID:</label>
                <asp:TextBox ID="txtEmpID" runat="server" Width="200px" />
            </div>

            <!-- Update Button -->
            <div style="margin-top:18px;">
                <asp:Button
                    ID="btnUpdateStatus"
                    runat="server"
                    CssClass="btn"
                    Text="Update Status Now"
                    OnClick="btnUpdateStatus_Click" />
            </div>

        </div>

    </div>

</form>

</body>
</html>
