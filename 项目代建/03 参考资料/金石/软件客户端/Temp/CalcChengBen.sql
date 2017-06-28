Create PROCEDURE [dbo].[CalcChengBen] 
@XMPathKey varchar(100),
@StartDate datetime,
@EndDate datetime,
@KuFangCheck bit,
@HasJiaGongCai bit, 
@ShenHeCheck bit,
@FBCBYiFuKuanShuCheck bit,
@KCFKCheck bit,
@KCFBHTDKGLF_SJCheck bit,
@ZZSTDCBCheck bit,
@totalcb float output
AS 
  declare @cs Varchar(20)
  declare @Tmpcb1 float
  declare @Tmpcb2 float
  declare @Tmpcb3 float
  declare @DateSql Varchar(1000)
  declare @DateSql_kaoqin Varchar(1000)
  
  declare @Sql Varchar(1000)  
  declare @issh bit
  declare @YWDJShenHeSql Varchar(20)  

  set @totalcb=0
  Set @DateSql=''
  Set @DateSql_kaoqin=''
  IF IsNULL(@StartDate,'')<>'' 
  Begin
    Set @DateSql=@DateSql+' And �������� >='''+cast(@StartDate as varchar(80))+''''
    Set @DateSql_kaoqin=@DateSql_kaoqin+' And �������� >='''+cast(@StartDate as varchar(80))+''''
  End
  IF IsNULL(@EndDate,'')<>'' 
  Begin
    Set @DateSql=@DateSql+' And �������� <='''+cast(@EndDate as varchar(80))+''''
    Set @DateSql_kaoqin=@DateSql_kaoqin+' And �������� <='''+cast(@EndDate as varchar(80))+''''
  End
 
  Set @YWDJShenHeSql='' 
  IF @issh=1 Begin set @YWDJShenHeSql=' And ��˷�=1 ' End 

  set @issh=0
  select @issh=���� From ϵͳȫ�����ñ� where ��������='���ϵ����е���ֻ����˺�ſɲ�����������' 
  
  
--  �ⷿcheck
  declare @sylw bit
  set @sylw=0
  select @sylw=���� From ϵͳȫ�����ñ� where ��������='ʹ���������ģ��'
  set @Sql=''  
  IF @KuFangCheck=1 Begin set @Sql='Declare cur1 Cursor Global For  Select Sum(���*(��Ŀ����+�ⷿ����)) As Ljcb from ������ϸ�� Where ����=0 And (��Ŀ����<>0 or �ⷿ����<>0) And CharIndex('''+@XMPathKey +''',XMPathKey)=1'  End
  IF @KuFangCheck=0 Begin set @Sql='Declare cur1 Cursor Global For  Select Sum(���*��Ŀ����) As Ljcb from ������ϸ�� Where ����=0 And ��Ŀ����<>0 And CharIndex('''+@XMPathKey +''',XMPathKey)=1' End 
  IF @HasJiaGongCai=0 Begin  set @sql=@sql+' And �׹���=0 ' End 
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
  Set @Sql=@sql+@DateSql 
  Set @Sql=@Sql+ @YWDJShenHeSql
  IF @ShenHeCheck=1 Begin set @Sql=@Sql+' And MainID In (Select AutoID From �������˱� where ��˷�=1 )' End 
  Set @Tmpcb1=0
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 
 

-- �������
  set @Sql='' 
  IF @sylw=1 
  Begin
    set @Sql='Declare cur1 Cursor Global For  Select Sum(���ʵ���*����) As Ljgz,Sum(�а���) As CBK from ��������ϸ�� Where MainID In (Select AutoID From ���������˱� where ����=0 And CharIndex('''+@XMPathKey +''',XMPathKey)=1 )'
    IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From ���������˱� where ��˷�=1 )' End
    Set @Sql=@Sql+@DateSql_kaoqin 
    Exec(@Sql)
    Open cur1
    Fetch Next From cur1 into @Tmpcb1,@Tmpcb2 
    Close cur1
    deallocate cur1 
    Set @totalcb=@totalcb+ISNULL(@tmpcb1,0)+ISNULL(@Tmpcb2 ,0)
  End 

-- ����˹�
  set @Sql=''
  IF @FBCBYiFuKuanShuCheck=0 
  Begin
    Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As Ljcb from ����˹���ϸ�� Where ����=0 And CharIndex('''+@XMPathKey +''',XMPathKey)=1'
    Set @Sql=@Sql+@DateSql
    IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From ����˹����˱� where ��˷�=1 )' End 
  End 
  IF @FBCBYiFuKuanShuCheck=1 
  Begin
    Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As Ljcb From �ո�����ϸ�� where ����=0 And CharIndex('''+@XMPathKey+''',XMPathKey)=1 And ��������=''���'' And ���������=''����˹���'' ' 
    Set @Sql=@Sql+' And MainID Not In (Select AutoID From �ո������˱� where ����=0 And �ո�������=''��Լ��֤��'') '
    Set @Sql=@Sql+@DateSql   
  End  
  Set @Tmpcb1=0
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 
 
 
-- �����е 
  Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As Ljcb from �����е��ϸ�� Where ����=0 And CharIndex('''+@XMPathKey +''',XMPathKey)=1'
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From �����е���˱� where ��˷�=1 )' End
  Set @Sql=@Sql+@DateSql  
  Set @Tmpcb1=0
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

-- ��������
  Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As Ljcb From ���޽�����ϸ�� where ����=0 And CharIndex('''+@XMPathKey +''',XMPathKey)=1' 
  Set @Sql=@Sql+@DateSql 
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From ���޽������˱� where ��˷�=1 )' End
  Set @Tmpcb1=0
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

-- ������
  Set @Sql='Declare cur1 Cursor Global For  Select  Sum(���) As Ljcb From ����������ϸ�� where ����=0 ' 
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 ' 
  Set @Sql=@Sql+@DateSql 
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From �����������˱� where ��˷�=1 )' End 
  Set @Tmpcb1=0
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 



--�̶��豸�̵�
  Set @Sql='Declare cur1 Cursor Global For  Select Sum(���) As Ljcb From �̶��豸��ϸ�� where ��������=''�豸�̵㵥''  And ����=0 '
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 ' 
  Set @Sql=@Sql+@DateSql  
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From �̶��豸���˱� where ��˷�=1 )' End
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 
 
--�̶��豸����
  Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As Ljcb From �̶��豸��ϸ�� where ��������=''�豸����''  And ����=0 '
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 ' 
  Set @Sql=@Sql+@DateSql  
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From �̶��豸���˱� where ��˷�=1 )' End
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

--���䳵��
  Set @Sql='Declare cur1 Cursor Global For  Select  Sum(���) As Ljcb from ���䳵����ϸ�� Where ����=0 And CharIndex('''+@XMPathKey +''',XMPathKey)=1'
  Set @Sql=@Sql+@DateSql 
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And MainID In (Select AutoID From ���䳵�����˱� where ��˷�=1 )' End
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

--����  
  declare @Ayear Int
  declare @AMmonth Int  
  Set @Sql='Declare cur1 Cursor Global For  Select Sum(�ϼƹ�*�ճɱ�) As HJ,Sum(�³ɱ�+�а���) As CBKHJ From �������˱�,������ϸ�� where �������˱�.AutoID=������ϸ��.MainID And ����=0 ' 
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
  IF IsNULL(@StartDate,'')<>''  
  Begin
    Set @Ayear=Year(@StartDate)
    Set @AMmonth=Month(@StartDate)
    Set @Sql=@Sql+' And (���>'+cast(@Ayear as varchar(8))+' or (���='+cast(@Ayear as varchar(8))+' And �·�>='+cast(@AMmonth as varchar(8))+'))'
  End 
  IF IsNULL(@EndDate,'')<>''  
  Begin
    Set @Ayear=Year(@EndDate)
    Set @AMmonth=Month(@EndDate)
    Set @Sql=@Sql+' And (���<'+cast(@Ayear as varchar(8))+' or (���='+cast(@Ayear as varchar(8))+' And �·�<='+cast(@AMmonth as varchar(8))+'))'
  End  
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1,@Tmpcb2
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0)+ISNULL(@tmpcb2,0) 

--Ԥ֧��ɱ�
  Set @Sql='Declare cur1 Cursor Global For  Select Sum(Ԥ֧����) As HJ From Ա��Ԥ֧�� where ����=0 ' 
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
  IF IsNULL(@StartDate,'')<>''  
  Begin
    Set @Ayear=Year(@StartDate)
    Set @AMmonth=Month(@StartDate)
    Set @Sql=@Sql+' And (���>'+cast(@Ayear as varchar(8))+' or (���='+cast(@Ayear as varchar(8))+' And �·�>='+cast(@AMmonth as varchar(8))+'))'
  End 
  IF IsNULL(@EndDate,'')<>''  
  Begin
    Set @Ayear=Year(@EndDate)
    Set @AMmonth=Month(@EndDate)
    Set @Sql=@Sql+' And (���<'+cast(@Ayear as varchar(8))+' or (���='+cast(@Ayear as varchar(8))+' And �·�<='+cast(@AMmonth as varchar(8))+'))'
  End  
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

--����Ԥ֧��ɱ�
  Set @Sql='Declare cur1 Cursor Global For  Select Sum(Ԥ֧����) As HJ From ����Ԥ֧�����˱�,����Ԥ֧����ϸ�� where ����Ԥ֧�����˱�.AutoID=����Ԥ֧����ϸ��.MainID And ����=0 '
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End 
  IF IsNULL(@StartDate,'')<>''  
  Begin
    Set @Ayear=Year(@StartDate)
    Set @AMmonth=Month(@StartDate)
    Set @Sql=@Sql+' And (���>'+cast(@Ayear as varchar(8))+' or (���='+cast(@Ayear as varchar(8))+' And �·�>='+cast(@AMmonth as varchar(8))+'))'
  End 
  IF IsNULL(@EndDate,'')<>''  
  Begin
    Set @Ayear=Year(@EndDate)
    Set @AMmonth=Month(@EndDate)
    Set @Sql=@Sql+' And (���<'+cast(@Ayear as varchar(8))+' or (���='+cast(@Ayear as varchar(8))+' And �·�<='+cast(@AMmonth as varchar(8))+'))'
  End  
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

--�豸ά��
  Set @Sql='Declare cur1 Cursor Global For Select  Sum(���) As Ljcb From �̶��豸ά�����˱� where ����=0  ' 
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
  Set @Sql=@Sql+@DateSql 
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

--�豸�۾�  
  Set @Sql='Declare cur1 Cursor Global For Select  Sum(���) As Ljcb From �̶��豸�۾����˱� where ����=0  '
  Set @Sql=@Sql+' And CharIndex('''+@XMPathKey+''',XMPathKey)=1 ' 
  Set @Sql=@Sql+@DateSql  
  IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @Tmpcb1 
  Close cur1
  deallocate cur1 
  Set @totalcb=@totalcb+ISNULL(@tmpcb1,0) 

--������� Ա������
  IF @KCFKCheck=1 
  Begin
    Set @Sql='Declare cur1 Cursor Global For Select Sum(������) As Ljcb From ������ where ����=0 And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
    Set @Sql=@Sql+@DateSql 
    IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
    Exec(@Sql)
    Open cur1
    Fetch Next From cur1 into @Tmpcb1 
    Close cur1
    deallocate cur1 
    Set @totalcb=@totalcb-ISNULL(@tmpcb1,0)
    
    Set @Sql='Declare cur1 Cursor Global For Select Sum(������) As Ljcb From Ա����� where ����=0 And CharIndex('''+@XMPathKey+''',XMPathKey)=1 '
    Set @Sql=@Sql+@DateSql  
    IF @ShenHeCheck=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
    Exec(@Sql)
    Open cur1
    Fetch Next From cur1 into @Tmpcb1 
    Close cur1
    deallocate cur1 
    Set @totalcb=@totalcb-ISNULL(@tmpcb1,0)
  End 

  IF @KCFBHTDKGLF_SJCheck=1 
  Begin
    Set @Sql='Declare cur1 Cursor Global For Select Sum(�����) As GLF ,Sum(˰��) As SJ,Sum(������) As QTF From �ְ���ͬ���۹����˰��� where MainID In (Select AutoID From �ְ���ͬ�� where CharIndex('''+@XMPathKey+''',XMPathKey)=1 )'
    Exec(@Sql)
    Open cur1
    Fetch Next From cur1 into @Tmpcb1,@Tmpcb2,@Tmpcb3 
    Close cur1
    deallocate cur1 
    Set @totalcb=@totalcb-(ISNULL(@tmpcb1,0)+ISNULL(@tmpcb2,0)+ISNULL(@tmpcb3,0)) 
  End

  IF @ZZSTDCBCheck=1
  Begin
    Set @Sql='Declare cur1 Cursor Global For Select Sum(Case When ҵ������=''�ս���Ʊ'' then �ɵֿ�˰�� Else 0 End) As JinXiang, Sum(Case When ҵ������=''������Ʊ'' then �ɵֿ�˰�� Else 0 End) As XiaoXiang From ��Ʊ���� where ��Ʊ���=''��ֵ˰��Ʊ'' '
    Set @Sql=@Sql+' And AutoID In (Select MainID From ��Ʊ�ӱ� where CharIndex('''+@XMPathKey+''',XMPathKey)=1 )' 
    Set @Sql=@Sql+@DateSql 
    Exec(@Sql)
    Open cur1
    Fetch Next From cur1 into @Tmpcb1,@Tmpcb2 
    Close cur1
    deallocate cur1 
    Set @totalcb=@totalcb-ISNULL(@tmpcb1,0)+ISNULL(@tmpcb2,0)  
  End

 