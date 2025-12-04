<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubmitAnnualLeave.aspx.cs" Inherits="HR.SubmitAnnualLeave" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Submit Annual Leave</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 SAKURA NAVBAR -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand">
                <span class="logo-dot"></span> UniBlossom HR
            </div>

            <ul class="nav">
                <li><a href="EmployeeHome.aspx">Dashboard</a></li>

                <li>
                    <a href="#" class="nav-btn">Attendance ▾</a>
                    <div class="dropdown-panel">
                        <a href="MyAttendance.aspx">My Attendance</a>
                        <a href="MyDeductions.aspx">My Deductions</a>
                    </div>
                </li>

                <li><a href="MyPayroll.aspx">Payroll</a></li>
                <li><a href="MyPerformance.aspx">Performance</a></li>

                <li>
                    <a href="#" class="nav-btn">Leaves ▾</a>
                    <div class="dropdown-panel">
                        <a href="SubmitAnnualLeave.aspx">Submit Annual Leave</a>
                        <a href="LeaveStatus.aspx">Leave Status</a>
                    </div>
                </li>

                <li><a href="MyDeductions.aspx">Deductions</a></li>
            </ul>

            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>
        </div>
    </header>

    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Submit Annual Leave</div>

        <div class="card">

            <label>Start Date</label>
            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date"></asp:TextBox>

            <label>End Date</label>
            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date"></asp:TextBox>

            <label>Replacement Employee ID (required)</label>
            <asp:TextBox ID="txtReplacement" runat="server" Width="150px"></asp:TextBox>

            <asp:Button ID="btnSubmitLeave" runat="server" Text="Submit Leave" CssClass="btn" OnClick="SubmitLeave_Click" />

            <asp:Label ID="lblMessage" runat="server" ForeColor="Green" CssClass="success"></asp:Label>
            <asp:Label ID="lblError" runat="server" ForeColor="Red" CssClass="error"></asp:Label>
        </div>
    </div>

</form>
</body>
</html>
