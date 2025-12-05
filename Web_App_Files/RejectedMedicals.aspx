<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RejectedMedicals.aspx.cs" Inherits="UNI.RejectedMedicals" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rejected Medical Leaves</title>

    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        /* Sakura card styling */
        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #eee;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            border: 1px solid #bbb;
            background: #fafafa;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn:hover {
            background: #f0e9ff;
            border-color: #c6b8f7;
        }

        .table {
            border: 1px solid #ddd;
            width: 100%;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 SAKURA NAVBAR (Admin) -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>
                UniBlossom HR (Admin)
            </div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

        </div>
    </header>

    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Rejected Medical Leaves</div>

        <div class="form-card">

            <!-- Messages -->
            <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
            <br />

            <!-- GridView -->
            <asp:GridView ID="gvRejectedMedicals"
                          runat="server"
                          AutoGenerateColumns="true"
                          CssClass="table">
            </asp:GridView>

            <br />

            <!-- Buttons -->
            <asp:Button ID="btnRefresh"
                        runat="server"
                        Text="Refresh"
                        CssClass="btn"
                        OnClick="btnRefresh_Click" />

            <asp:Button ID="btnBack"
                        runat="server"
                        Text="Back to Admin Home"
                        CssClass="btn"
                        OnClick="btnBack_Click" />

        </div>

    </div>

</form>
</body>
</html>
