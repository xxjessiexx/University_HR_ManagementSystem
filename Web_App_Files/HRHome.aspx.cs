using System;
using System.Web.UI;

namespace UNI
{
    public partial class HRHome : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["HRID"] == null)
                {
                    Response.Redirect("LogIn.aspx");
                    return;
                }

                lblWelcome.Text = $"Welcome HR (Employee ID: {Session["HRID"]})";
            }
        }

        protected void btnLeaves_Click(object sender, EventArgs e)
        {
            Response.Redirect("HRApproval.aspx");
        }

        protected void btnDeductions_Click(object sender, EventArgs e)
        {
            Response.Redirect("HRDeductions.aspx");
        }

        protected void btnPayroll_Click(object sender, EventArgs e)
        {
            Response.Redirect("HRPayroll.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("LogIn.aspx");
        }
    }
}
