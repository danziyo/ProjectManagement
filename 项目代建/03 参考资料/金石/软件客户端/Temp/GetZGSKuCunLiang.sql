Create function [dbo].[GetZGSKuCunLiang](@GZ varchar(30) ,@MC varchar(100),@DW varchar(50),@GG varchar(50),@PP varchar(50))
Returns Float
As
Begin
  Declare @KCL Float
  IF @GZ<>'' And @PP<>'' 
  Begin
    Declare cur1 Cursor For (Select Sum(����*�ⷿ����) As Ljsl From ������ϸ�� where ����=0 And ����=@GZ And ����=@MC And ��λ=@DW And ���=@GG And Ʒ��=@PP And MainID In (Select AutoID From �������˱� where ����=0 And IsCK=1)  )
  End Else IF @GZ<>'' 
  Begin
    Declare cur1 Cursor For (Select Sum(����*�ⷿ����) As Ljsl From ������ϸ�� where ����=0 And ����=@GZ And ����=@MC And ��λ=@DW And ���=@GG And MainID In (Select AutoID From �������˱� where ����=0 And IsCK=1)  )
  End Else IF @PP<>''
  Begin
    Declare cur1 Cursor For (Select Sum(����*�ⷿ����) As Ljsl From ������ϸ�� where ����=0 And ����=@GZ And ����=@MC And ��λ=@DW And Ʒ��=@PP And MainID In (Select AutoID From �������˱� where ����=0 And IsCK=1)  )
  End Else
  Begin
    Declare cur1 Cursor For (Select Sum(����*�ⷿ����) As Ljsl From ������ϸ�� where ����=0 And ����=@GZ And ����=@MC And ��λ=@DW And MainID In (Select AutoID From �������˱� where ����=0 And IsCK=1)  )
  End
  
  Open cur1
  Fetch Next From cur1 into @KCL
 
  Return ISNULL(@KCL,0) 
 
End