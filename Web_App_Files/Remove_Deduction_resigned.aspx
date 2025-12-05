<<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RemoveDeductions.aspx.cs" Inherits="UNI.RemoveDeductions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Remove Deductions</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        .card-centered {
            max-width: 850px;
            margin: auto;
            padding: 25px;
            border-radius: 12px;
            background: #ffffff;
            border: 1px solid #f6d8ea;
            box-shadow: 0 3px 10px rgba(255, 105, 180, 0.12);
            margin-bottom: 25px;
        }

        .page-title {
            font-size: 26px;
            font-weight: bold;
            color: #d63384;
            margin-bottom: 20px;
            text-align: center;
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

        .btn-block {
            width: 60%;
            margin: 10px auto;
            display: block;
        }

        .msg-error {
            color: #d9534f;
            font-weight: bold;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <!-- 🌸 ADMIN NAVBAR -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand"><span class="logo-dot"></span>UniBlossom HR (Admin)</div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <!-- No logout button for admin utility pages -->
            </div>

        </div>
    </header>


    <!-- 🌸 CONTENT -->
    <div class="container-page">

        <div class="page-title">Remove Deductions for Resigned Employees</div>

        <!-- ACTION CARD -->
        <div class="card-centered">

            <asp:Button
                ID="btnRemove"
                runat="server"
                CssClass="btn btn-block"
                Text="Remove Deductions"
                OnClick="btnRemove_Click" />

            <asp:Label
                ID="lblMsg"
                runat="server"
                CssClass="msg-error"
                Visible="false">
            </asp:Label>

        </div>

        <!-- BACK BUTTON CARD -->
        <div class="card-centered">
            <asp:Button
                ID="btnBack"
                runat="server"
                CssClass="btn btn-block"
                Text="Back to Admin Home"
                OnClick="btnBack_Click" />
        </div>

    </div>

</form>

</body>
</html>
