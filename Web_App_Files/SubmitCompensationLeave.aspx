<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubmitCompensationLeave.aspx.cs" Inherits="UNI.SubmitCompensationLeave" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <title>Submit Compensation Leave</title>
<link rel="stylesheet" href="Styles/site.css" />
</head>
<body>
    <form id="form1" runat="server">

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

     <div class="page-title">Submit Compensation Leave</div>

     <div class="card">
         <label>Employee ID</label>
         <asp:TextBox ID="empId" runat="server"></asp:TextBox>

         <label>Date Of Compensation</label>
         <asp:TextBox ID="comp_date" runat="server" TextMode="Date"></asp:TextBox>

         <label>Reason</label>
         <asp:TextBox ID="reason" runat="server"></asp:TextBox>

         <label>Date of Original Workday</label>
         <asp:TextBox ID="original_date" runat="server" TextMode="Date" Width="150px"></asp:TextBox>

         <label>Replacement Employee ID</label>
         <asp:TextBox ID="replace_ID" runat="server" Width="150px"></asp:TextBox>

         <asp:Button ID="btnSubmitLeave" runat="server" Text="Submit Leave" CssClass="btn" OnClick="Submit_compensation" />

         <br />
         <asp:Label ID="mssg" runat="server" Visible="false"></asp:Label>
     </div>
 </div>
    </form>
</body>
</html>
