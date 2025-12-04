<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProcessingUnpaidLeave.aspx.cs" Inherits="UNI.ProcessingUnpaidLeave" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Processing Unpaid Leave</title>
<link rel="stylesheet" href="Styles/site.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!--navbar-->
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
         <div class="container-page">

     <div class="page-title">Processing Unpaid Leaves</div>

     <div class="card">
         <label>Request ID</label>
         <asp:TextBox ID="req_id" runat="server"></asp:TextBox>

         <label>Approver ID</label>
         <asp:TextBox ID="upper_id" runat="server"></asp:TextBox>

         <asp:Button ID="btnProcessLeave" runat="server" Text="Process Leave" CssClass="btn" OnClick="Process" />
         <br />
         <asp:Label ID="mssg" runat="server" Visible="false"></asp:Label>
     </div>
 </div>
    </form>
</body>
</html>
