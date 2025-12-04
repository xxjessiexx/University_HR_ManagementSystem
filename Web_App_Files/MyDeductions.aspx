<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyDeductions.aspx.cs" Inherits="HR.MyDeductions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendance Deductions</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
<form id="form1" runat="server">

    <!-- Sakura Navbar -->
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
            <a href="SubmitAccidentalLeave.aspx">Submit Accidental Leave</a>
            <a href="SubmitCompensationLeave.aspx">Submit Compensation Leave</a>
            <a href="SubmitMedicalLeave.aspx">Submit Medical Leave</a>
            <a href="SubmitUnpaidLeave.aspx">Submit Unpaid Leave</a>
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

    <!-- Page Body -->
    <div class="container-page">

        <div class="page-title">Attendance Deductions</div>

        <!-- Input Card -->
        <div class="card">
            <label>Enter Month (1–12)</label>
            <asp:TextBox ID="txtMonth" runat="server" Width="80px"></asp:TextBox>

            <asp:Button ID="btnGetDeductions"
                        runat="server"
                        CssClass="btn"
                        Text="Load Deductions"
                        OnClick="GetDeductions_Click" />

            <asp:Label ID="errorLabel"
                       runat="server"
                       Visible="false"
                       CssClass="error"></asp:Label>
        </div>

        <!-- Results Card -->
        <div class="card">
            <asp:GridView ID="gvDeductions"
                          runat="server"
                          CssClass="table"
                          AutoGenerateColumns="true"
                          GridLines="None"></asp:GridView>
        </div>

    </div>

</form>
</body>
</html>
